// File: src/pages/WorkOrder.jsx
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

const WorkOrder = () => {
    const [woList, setWoList] = useState([]);
    const [formData, setFormData] = useState({
        no_wo: '', cabang: '', no_polisi: '', keluhan: '', estimasi_biaya: 0
    });
    const navigate = useNavigate();

    // Mengambil data user yang sedang login untuk mengecek role
    const userString = localStorage.getItem('user');
    const user = userString ? JSON.parse(userString) : null;

    const fetchWO = async () => {
        try {
            const response = await api.get('/work-order');
            setWoList(response.data);
        } catch (error) {
            console.error("Gagal mengambil data Work Order", error);
        }
    };

    useEffect(() => {
        fetchWO();
    }, []);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleCreateWO = async (e) => {
        e.preventDefault();
        try {
            await api.post('/work-order', formData);
            alert('Work Order berhasil dibuat!');
            setFormData({ no_wo: '', cabang: '', no_polisi: '', keluhan: '', estimasi_biaya: 0 });
            fetchWO();
        } catch (error) {
            alert(error.response?.data?.message || 'Terjadi kesalahan saat membuat WO');
        }
    };

    const handleUpdateStatus = async (no_wo, status_baru) => {
        try {
            await api.put(`/work-order/${no_wo}/status`, { status_baru });
            alert(`Status WO ${no_wo} berhasil diubah menjadi ${status_baru}`);
            fetchWO();
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal mengubah status');
        }
    };

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial' }}>
            <button onClick={() => navigate('/dashboard')}>&larr; Kembali ke Dashboard</button>
            <h2>Manajemen Work Order (WO)</h2>

            {/* FORM TAMBAH WO (Hanya Admin Cabang yang biasanya membuka WO baru)[cite: 4] */}
            {user?.role === 'admin_cabang' && (
                <div style={{ border: '1px solid #ccc', padding: '15px', marginBottom: '20px', maxWidth: '500px' }}>
                    <h3>Buat Work Order Baru</h3>
                    <form onSubmit={handleCreateWO} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                        <input type="text" name="no_wo" placeholder="Nomor WO (Contoh: WO-1001)" value={formData.no_wo} onChange={handleChange} required />
                        <input type="text" name="cabang" placeholder="Kode Cabang (Contoh: CBG01)" value={formData.cabang} onChange={handleChange} required />
                        <input type="text" name="no_polisi" placeholder="Nomor Polisi (Contoh: KH 1234 AB)" value={formData.no_polisi} onChange={handleChange} required />
                        <textarea name="keluhan" placeholder="Keluhan Pelanggan" value={formData.keluhan} onChange={handleChange} required />
                        <input type="number" name="estimasi_biaya" placeholder="Estimasi Biaya" value={formData.estimasi_biaya} onChange={handleChange} />
                        <button type="submit">Buat Work Order</button>
                    </form>
                </div>
            )}

            {/* TABEL DAFTAR WO */}
            <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                <thead>
                    <tr style={{ background: '#eee' }}>
                        <th>No WO</th>
                        <th>Tanggal Masuk</th>
                        <th>No Polisi</th>
                        <th>Pemilik</th>
                        <th>Keluhan</th>
                        <th>Status</th>
                        <th>Aksi Status</th>
                    </tr>
                </thead>
                <tbody>
                    {woList.map((wo) => (
                        <tr key={wo.no_wo}>
                            <td>{wo.no_wo}</td>
                            <td>{new Date(wo.tanggal_masuk).toLocaleString()}</td>
                            <td>{wo.no_polisi}</td>
                            <td>{wo.nama_pel}</td>
                            <td>{wo.keluhan}</td>
                            <td><strong>{wo.status_pekerjaan.toUpperCase()}</strong></td>
                            <td>
                                {/* Mekanik dan Admin dapat mengubah status pekerjaan[cite: 4] */}
                                {(user?.role === 'admin_cabang' || user?.role === 'mekanik') && wo.status_pekerjaan !== 'selesai' && (
                                    <>
                                        <button onClick={() => handleUpdateStatus(wo.no_wo, 'proses')} style={{ marginRight: '5px' }}>Proses</button>
                                        <button onClick={() => handleUpdateStatus(wo.no_wo, 'selesai')} style={{ marginRight: '5px' }}>Selesai</button>
                                        <button onClick={() => handleUpdateStatus(wo.no_wo, 'batal')}>Batal</button>
                                    </>
                                )}
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default WorkOrder;