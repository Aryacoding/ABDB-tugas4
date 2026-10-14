// File: controllers/woController.js
const db = require('../config/db');

// Read - Get Semua Work Order
const getAllWO = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT w.no_wo, w.tanggal_masuk, w.cabang, w.no_polisi, w.keluhan, w.status_pekerjaan, p.nama_pel 
            FROM work_order w
            JOIN motor m ON w.no_polisi = m.no_polisi
            JOIN pelanggan p ON m.id_pel = p.id_pel
            ORDER BY w.tanggal_masuk DESC
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Create - Membuat Work Order Baru (Default status: antrean)
const createWO = async (req, res) => {
    const { no_wo, cabang, no_polisi, keluhan, estimasi_biaya } = req.body;
    try {
        await db.query(
            `INSERT INTO work_order (no_wo, cabang, no_polisi, keluhan, estimasi_biaya, status_pekerjaan) 
             VALUES (?, ?, ?, ?, ?, 'antrean')`,
            [no_wo, cabang, no_polisi, keluhan, estimasi_biaya || 0]
        );
        res.status(201).json({ message: 'Work Order berhasil dibuat', no_wo });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Create - Menambahkan Jasa ke Work Order
const addJasaToWO = async (req, res) => {
    const { no_wo } = req.params;
    const { kode_jasa, harga_diterapkan } = req.body;
    try {
        await db.query(
            'INSERT INTO wo_jasa (no_wo, kode_jasa, harga_diterapkan) VALUES (?, ?, ?)',
            [no_wo, kode_jasa, harga_diterapkan]
        );
        res.status(201).json({ message: 'Jasa berhasil ditambahkan ke Work Order' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Create - Menambahkan Suku Cadang ke Work Order
const addPartToWO = async (req, res) => {
    const { no_wo } = req.params;
    const { kode_part, kode_cabang, qty_part, harga_satuan_saat_transaksi } = req.body;
    try {
        // Trigger trg_kurangi_stok_part di database akan otomatis memotong stok cabang saat baris ini dieksekusi
        await db.query(
            'INSERT INTO wo_part (no_wo, kode_part, kode_cabang, qty_part, harga_satuan_saat_transaksi) VALUES (?, ?, ?, ?, ?)',
            [no_wo, kode_part, kode_cabang, qty_part, harga_satuan_saat_transaksi]
        );
        res.status(201).json({ message: 'Suku cadang berhasil ditambahkan ke Work Order' });
    } catch (error) {
        // Menangkap error dari validasi stok pada trigger (jika stok kurang)
        if (error.sqlState === '45000') {
            return res.status(400).json({ message: error.message });
        }
        res.status(500).json({ message: error.message });
    }
};

// Update - Mengubah Status Work Order menggunakan Stored Procedure
const updateStatusWO = async (req, res) => {
    const { no_wo } = req.params;
    const { status_baru } = req.body; 
    // status_baru harus salah satu dari: 'antrean', 'proses', 'selesai', 'batal'
    
    try {
        await db.query('CALL sp_update_status_work_order(?, ?)', [no_wo, status_baru]);
        res.json({ message: `Status Work Order ${no_wo} berhasil diubah menjadi ${status_baru}` });
    } catch (error) {
        if (error.sqlState === '45000') {
            return res.status(400).json({ message: error.message });
        }
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getAllWO, createWO, addJasaToWO, addPartToWO, updateStatusWO };