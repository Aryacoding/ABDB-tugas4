// File: controllers/motorController.js
const db = require('../config/db');

// Read - Get Semua Motor beserta nama pemiliknya
const getAllMotor = async (req, res) => {
    try {
        const query = `
            SELECT m.*, p.nama_pel, p.kategori_pelanggan 
            FROM motor m
            JOIN pelanggan p ON m.id_pel = p.id_pel
        `;
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Read - Get Motor Berdasarkan No Polisi
const getMotorById = async (req, res) => {
    const { no_polisi } = req.params;
    try {
        const [rows] = await db.query('SELECT * FROM motor WHERE no_polisi = ?', [no_polisi]);
        if (rows.length === 0) return res.status(404).json({ message: 'Motor tidak ditemukan' });
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Create - Tambah Motor
const createMotor = async (req, res) => {
    const { no_polisi, nomor_rangka, nomor_mesin, merek_mtr, tipe_mtr, tahun_mtr, warna_mtr, KM_mtr, id_pel } = req.body;
    try {
        await db.query(
            `INSERT INTO motor (no_polisi, nomor_rangka, nomor_mesin, merek_mtr, tipe_mtr, tahun_mtr, warna_mtr, KM_mtr, id_pel) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [no_polisi, nomor_rangka, nomor_mesin, merek_mtr, tipe_mtr, tahun_mtr, warna_mtr, KM_mtr || 0, id_pel]
        );
        res.status(201).json({ message: 'Data motor berhasil ditambahkan', no_polisi });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ message: 'Nomor Polisi, Nomor Rangka, atau Nomor Mesin sudah terdaftar!' });
        }
        res.status(500).json({ message: error.message });
    }
};

// Update - Ubah Data Motor
const updateMotor = async (req, res) => {
    const { no_polisi } = req.params;
    const { merek_mtr, tipe_mtr, tahun_mtr, warna_mtr, KM_mtr, id_pel } = req.body;
    
    try {
        const [result] = await db.query(
            `UPDATE motor 
             SET merek_mtr=?, tipe_mtr=?, tahun_mtr=?, warna_mtr=?, KM_mtr=?, id_pel=? 
             WHERE no_polisi=?`,
            [merek_mtr, tipe_mtr, tahun_mtr, warna_mtr, KM_mtr, id_pel, no_polisi]
        );

        if (result.affectedRows === 0) return res.status(404).json({ message: 'Motor tidak ditemukan' });
        res.json({ message: 'Data motor berhasil diperbarui' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Delete - Hapus Data Motor
const deleteMotor = async (req, res) => {
    const { no_polisi } = req.params;
    try {
        const [result] = await db.query('DELETE FROM motor WHERE no_polisi = ?', [no_polisi]);
        if (result.affectedRows === 0) return res.status(404).json({ message: 'Motor tidak ditemukan' });
        res.json({ message: 'Data motor berhasil dihapus' });
    } catch (error) {
        if (error.code === 'ER_ROW_IS_REFERENCED_2') {
            return res.status(400).json({ message: 'Gagal! Motor ini memiliki riwayat Work Order yang tidak bisa dihapus sembarangan.' });
        }
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getAllMotor, getMotorById, createMotor, updateMotor, deleteMotor };