// File: controllers/laporanController.js
const db = require('../config/db');

// Laporan 1: Riwayat servis per motor memanggil SP sp_riwayat_servis_nopol[cite: 3, 4]
const getRiwayatServis = async (req, res) => {
    const { no_polisi } = req.params;
    try {
        const [rows] = await db.query('CALL sp_riwayat_servis_nopol(?)', [no_polisi]);
        res.json(rows[0]); 
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Laporan 2: Total pendapatan per cabang dan rentang tanggal menggunakan JOIN
const getPendapatanCabang = async (req, res) => {
    const { tgl_mulai, tgl_akhir } = req.query; // Diterima melalui query params, cth: ?tgl_mulai=2023-01-01&tgl_akhir=2023-12-31
    try {
        const [rows] = await db.query(`
            SELECT w.cabang, SUM(p.total_biaya_akhir) AS total_pendapatan
            FROM pembayaran p
            JOIN work_order w ON p.no_wo = w.no_wo
            WHERE p.status_pembayaran = 'lunas' 
              AND DATE(p.tanggal_bayar) BETWEEN ? AND ?
            GROUP BY w.cabang
        `, [tgl_mulai, tgl_akhir]);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Laporan 3: Penggunaan suku cadang per work order menggunakan JOIN
const getPenggunaanPart = async (req, res) => {
    const { no_wo } = req.params;
    try {
        const [rows] = await db.query(`
            SELECT wp.no_wo, p.nama_part, wp.qty_part, wp.harga_satuan_saat_transaksi
            FROM wo_part wp
            JOIN part p ON wp.kode_part = p.kode_part
            WHERE wp.no_wo = ?
        `, [no_wo]);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Laporan 4: Daftar stok suku cadang yang berada di bawah stok minimum menggunakan JOIN[cite: 4]
const getStokMinimum = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT s.kode_cabang, p.nama_part, s.jumlah_stok, s.stok_minimum
            FROM stok_cabang s
            JOIN part p ON s.kode_part = p.kode_part
            WHERE s.jumlah_stok < s.stok_minimum
        `);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getRiwayatServis, getPendapatanCabang, getPenggunaanPart, getStokMinimum };