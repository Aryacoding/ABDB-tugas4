// File: controllers/inventoryController.js
const db = require('../config/db');

// --- CRUD PART (SUKU CADANG) ---
const getAllPart = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM part');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const createPart = async (req, res) => {
    const { kode_part, nama_part, harga_beli, harga_satuan } = req.body;
    try {
        await db.query(
            'INSERT INTO part (kode_part, nama_part, harga_beli, harga_satuan) VALUES (?, ?, ?, ?)',
            [kode_part, nama_part, harga_beli, harga_satuan]
        );
        res.status(201).json({ message: 'Suku cadang berhasil ditambahkan', kode_part });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const updatePart = async (req, res) => {
    const { kode_part } = req.params;
    const { nama_part, harga_beli, harga_satuan } = req.body;
    try {
        const [result] = await db.query(
            'UPDATE part SET nama_part=?, harga_beli=?, harga_satuan=? WHERE kode_part=?',
            [nama_part, harga_beli, harga_satuan, kode_part]
        );
        if (result.affectedRows === 0) return res.status(404).json({ message: 'Suku cadang tidak ditemukan' });
        res.json({ message: 'Suku cadang berhasil diperbarui' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// --- CRUD PEMASOK (SUPPLIER) ---
const getAllPemasok = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM pemasok');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const createPemasok = async (req, res) => {
    const { nama_pemasok, alamat, nomor_telepon, email } = req.body;
    try {
        const [result] = await db.query(
            'INSERT INTO pemasok (nama_pemasok, alamat, nomor_telepon, email) VALUES (?, ?, ?, ?)',
            [nama_pemasok, alamat, nomor_telepon, email]
        );
        res.status(201).json({ message: 'Supplier berhasil ditambahkan', id_pemasok: result.insertId });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getAllPart, createPart, updatePart, getAllPemasok, createPemasok };