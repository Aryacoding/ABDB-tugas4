// File: controllers/pelangganController.js
const db = require('../config/db');

// Read - Get Semua Pelanggan
const getAllPelanggan = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM pelanggan');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Create - Tambah Pelanggan (Sudah mendukung pelanggan korporat)
const createPelanggan = async (req, res) => {
    const { 
        nama_pel, telp_pel, alamat_pel, jenis_id, 
        kategori_pelanggan, nama_perusahaan, plafon_kredit 
    } = req.body;
    
    try {
        // Jika pelanggan individu, nilai perusahaan & kredit di-set null/0
        const kat_pelanggan = kategori_pelanggan || 'individu';
        const perusahaan = kat_pelanggan === 'korporat' ? nama_perusahaan : null;
        const kredit = kat_pelanggan === 'korporat' ? (plafon_kredit || 0) : 0;

        const [result] = await db.query(
            `INSERT INTO pelanggan (nama_pel, telp_pel, alamat_pel, jenis_id, kategori_pelanggan, nama_perusahaan, plafon_kredit, sisa_kredit) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
            [nama_pel, telp_pel, alamat_pel, jenis_id, kat_pelanggan, perusahaan, kredit, kredit] // sisa_kredit awal = plafon_kredit
        );
        res.status(201).json({ message: 'Pelanggan berhasil ditambahkan', id_pel: result.insertId });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Update - Ubah Data Pelanggan
const updatePelanggan = async (req, res) => {
    const { id } = req.params;
    const { 
        nama_pel, telp_pel, alamat_pel, jenis_id, 
        kategori_pelanggan, nama_perusahaan, plafon_kredit 
    } = req.body;

    try {
        const [result] = await db.query(
            `UPDATE pelanggan 
             SET nama_pel=?, telp_pel=?, alamat_pel=?, jenis_id=?, 
                 kategori_pelanggan=?, nama_perusahaan=?, plafon_kredit=? 
             WHERE id_pel=?`,
            [nama_pel, telp_pel, alamat_pel, jenis_id, kategori_pelanggan, nama_perusahaan, plafon_kredit, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Pelanggan tidak ditemukan' });
        }
        res.json({ message: 'Data pelanggan berhasil diperbarui' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Delete - Hapus Data Pelanggan
const deletePelanggan = async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM pelanggan WHERE id_pel = ?', [id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Pelanggan tidak ditemukan' });
        }
        res.json({ message: 'Data pelanggan berhasil dihapus' });
    } catch (error) {
        // Menangkap error jika pelanggan masih memiliki relasi di tabel motor (Foreign Key Constraint)
        if (error.code === 'ER_ROW_IS_REFERENCED_2') {
            return res.status(400).json({ message: 'Gagal menghapus! Pelanggan ini masih memiliki data motor yang terdaftar.' });
        }
        res.status(500).json({ message: error.message });
    }
};

module.exports = { getAllPelanggan, createPelanggan, updatePelanggan, deletePelanggan };