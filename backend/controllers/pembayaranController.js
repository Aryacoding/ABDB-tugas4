// File: controllers/pembayaranController.js
const db = require('../config/db');

// Mengira jumlah tagihan menggunakan Stored Procedure
const getTotalTagihan = async (req, res) => {
    const { no_wo } = req.params;
    try {
        // Stored procedure sp_hitung_total_tagihan_wo menggunakan parameter OUT[cite: 3]
        await db.query('SET @total = 0');
        await db.query('CALL sp_hitung_total_tagihan_wo(?, @total)', [no_wo]);
        const [rows] = await db.query('SELECT @total AS total_tagihan');
        
        res.json({ no_wo, total_tagihan: rows[0].total_tagihan });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Mencatat pembayaran baharu ke pangkalan data
const prosesPembayaran = async (req, res) => {
    const { no_wo, total_biaya_akhir, metode_pembayaran, catatan } = req.body;
    try {
        await db.query(
            `INSERT INTO pembayaran (no_wo, total_biaya_akhir, metode_pembayaran, status_pembayaran, catatan) 
             VALUES (?, ?, ?, 'lunas', ?)`,
            [no_wo, total_biaya_akhir, metode_pembayaran, catatan]
        );
        
        // Kemas kini status Work Order menjadi selesai
        await db.query('UPDATE work_order SET status_pekerjaan = "selesai" WHERE no_wo = ?', [no_wo]);
        
        res.status(201).json({ message: 'Pembayaran berjaya direkodkan dan status WO dikemas kini' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getTotalTagihan, prosesPembayaran };