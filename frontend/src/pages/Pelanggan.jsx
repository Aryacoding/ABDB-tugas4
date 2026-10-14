// File: src/pages/Pelanggan.jsx
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

const Pelanggan = () => {
    const [pelangganList, setPelangganList] = useState([]);
    const [formData, setFormData] = useState({
        nama_pel: '', telp_pel: '', alamat_pel: '', jenis_id: 'KTP',
        kategori_pelanggan: 'individu', nama_perusahaan: '', plafon_kredit: ''
    });
    
    // State untuk mode edit
    const [isEdit, setIsEdit] = useState(false);
    const [editId, setEditId] = useState(null);
    const navigate = useNavigate();

    // GET: Mengambil data pelanggan dari backend
    const fetchPelanggan = async () => {
        try {
            const response = await api.get('/pelanggan');
            setPelangganList(response.data);
        } catch (error) {
            console.error("Gagal mengambil data pelanggan", error);
        }
    };

    useEffect(() => {
        fetchPelanggan();
    }, []);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    // POST & PUT: Simpan atau Update data pelanggan[cite: 4]
    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            if (isEdit) {
                // Proses Update
                await api.put(`/pelanggan/${editId}`, formData);
                alert('Pelanggan berhasil diperbarui!');
            } else {
                // Proses Create
                await api.post('/pelanggan', formData);
                alert('Pelanggan berhasil ditambahkan!');
            }
            
            // Reset form setelah sukses
            resetForm();
            fetchPelanggan(); // Refresh tabel
        } catch (error) {
            alert(error.response?.data?.message || 'Terjadi kesalahan');
        }
    };

    // DELETE: Menghapus data pelanggan[cite: 4]
    const handleDelete = async (id) => {
        const confirmDelete = window.confirm('Apakah Anda yakin ingin menghapus pelanggan ini?');
        if (!confirmDelete) return;

        try {
            await api.delete(`/pelanggan/${id}`);
            alert('Pelanggan berhasil dihapus!');
            fetchPelanggan();
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal menghapus pelanggan');
        }
    };

    // Fungsi untuk mengisi form dengan data yang akan di-edit
    const handleEditClick = (pel) => {
        setIsEdit(true);
        setEditId(pel.id_pel);
        setFormData({
            nama_pel: pel.nama_pel,
            telp_pel: pel.telp_pel,
            alamat_pel: pel.alamat_pel || '',
            jenis_id: pel.jenis_id,
            kategori_pelanggan: pel.kategori_pelanggan,
            nama_perusahaan: pel.nama_perusahaan || '',
            plafon_kredit: pel.plafon_kredit || ''
        });
        
        // Scroll otomatis ke atas form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const resetForm = () => {
        setIsEdit(false);
        setEditId(null);
        setFormData({
            nama_pel: '', telp_pel: '', alamat_pel: '', jenis_id: 'KTP',
            kategori_pelanggan: 'individu', nama_perusahaan: '', plafon_kredit: ''
        });
    };

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial' }}>
            <button onClick={() => navigate('/dashboard')}>&larr; Kembali ke Dashboard</button>
            <h2>Manajemen Data Pelanggan</h2>

            {/* FORM TAMBAH / EDIT PELANGGAN */}
            <div style={{ border: '1px solid #ccc', padding: '15px', marginBottom: '20px', maxWidth: '500px' }}>
                <h3>{isEdit ? 'Edit Data Pelanggan' : 'Tambah Pelanggan Baru'}</h3>
                <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    <input type="text" name="nama_pel" placeholder="Nama Lengkap" value={formData.nama_pel} onChange={handleChange} required />
                    <input type="text" name="telp_pel" placeholder="Nomor Telepon" value={formData.telp_pel} onChange={handleChange} required />
                    <textarea name="alamat_pel" placeholder="Alamat" value={formData.alamat_pel} onChange={handleChange} required />
                    
                    <select name="jenis_id" value={formData.jenis_id} onChange={handleChange}>
                        <option value="KTP">KTP</option>
                        <option value="SIM">SIM</option>
                        <option value="Paspor">Paspor</option>
                    </select>

                    <select name="kategori_pelanggan" value={formData.kategori_pelanggan} onChange={handleChange}>
                        <option value="individu">Individu</option>
                        <option value="korporat">Korporat (Perusahaan)</option>
                    </select>

                    {/* Form tambahan muncul jika kategori korporat dipilih[cite: 4] */}
                    {formData.kategori_pelanggan === 'korporat' && (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', background: '#f9f9f9', padding: '10px' }}>
                            <input type="text" name="nama_perusahaan" placeholder="Nama Perusahaan" value={formData.nama_perusahaan} onChange={handleChange} required />
                            <input type="number" name="plafon_kredit" placeholder="Plafon Kredit (Rp)" value={formData.plafon_kredit} onChange={handleChange} required />
                        </div>
                    )}

                    <div style={{ display: 'flex', gap: '10px' }}>
                        <button type="submit" style={{ flex: 1, background: isEdit ? 'orange' : 'green', color: 'white' }}>
                            {isEdit ? 'Update Pelanggan' : 'Simpan Pelanggan'}
                        </button>
                        {isEdit && (
                            <button type="button" onClick={resetForm} style={{ flex: 1, background: 'gray', color: 'white' }}>Batal</button>
                        )}
                    </div>
                </form>
            </div>

            {/* TABEL DAFTAR PELANGGAN DENGAN TOMBOL CRUD */}
            <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                <thead>
                    <tr style={{ background: '#eee' }}>
                        <th>ID</th>
                        <th>Nama</th>
                        <th>Telepon</th>
                        <th>Kategori</th>
                        <th>Perusahaan</th>
                        <th>Plafon Kredit</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    {pelangganList.map((pel) => (
                        <tr key={pel.id_pel}>
                            <td>{pel.id_pel}</td>
                            <td>{pel.nama_pel}</td>
                            <td>{pel.telp_pel}</td>
                            <td>{pel.kategori_pelanggan}</td>
                            <td>{pel.nama_perusahaan || '-'}</td>
                            <td>{pel.plafon_kredit > 0 ? `Rp ${pel.plafon_kredit}` : '-'}</td>
                            <td>
                                <button 
                                    onClick={() => handleEditClick(pel)} 
                                    style={{ marginRight: '5px', background: 'orange', border: 'none', padding: '5px 10px', cursor: 'pointer' }}>
                                    Edit
                                </button>
                                <button 
                                    onClick={() => handleDelete(pel.id_pel)} 
                                    style={{ background: 'red', color: 'white', border: 'none', padding: '5px 10px', cursor: 'pointer' }}>
                                    Hapus
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default Pelanggan;