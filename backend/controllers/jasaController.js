// File: controllers/jasaController.js
const db = require('../config/db');

const getAllJasa = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM jasa');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const createJasa = async (req, res) => {
    const { kode_jasa, uraian_jasa, biaya_jasa, keahlian_mek } = req.body;
    try {
        const [result] = await db.query(
            'INSERT INTO jasa (kode_jasa, uraian_jasa, biaya_jasa, keahlian_mek) VALUES (?, ?, ?, ?)',
            [kode_jasa, uraian_jasa, biaya_jasa, keahlian_mek]
        );
        res.status(201).json({ message: 'Jasa berhasil ditambahkan', id_jasa: result.insertId });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const updateJasa = async (req, res) => {
    const { id } = req.params;
    const { kode_jasa, uraian_jasa, biaya_jasa, keahlian_mek } = req.body;
    try {
        const [result] = await db.query(
            'UPDATE jasa SET kode_jasa=?, uraian_jasa=?, biaya_jasa=?, keahlian_mek=? WHERE id_jasa=?',
            [kode_jasa, uraian_jasa, biaya_jasa, keahlian_mek, id]
        );
        if (result.affectedRows === 0) return res.status(404).json({ message: 'Jasa tidak ditemukan' });
        res.json({ message: 'Jasa berhasil diperbarui' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const deleteJasa = async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM jasa WHERE id_jasa = ?', [id]);
        if (result.affectedRows === 0) return res.status(404).json({ message: 'Jasa tidak ditemukan' });
        res.json({ message: 'Jasa berhasil dihapus' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getAllJasa, createJasa, updateJasa, deleteJasa };