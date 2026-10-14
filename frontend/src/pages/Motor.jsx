// File: src/pages/Motor.jsx
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

const Motor = () => {
    const [motorList, setMotorList] = useState([]);
    const [formData, setFormData] = useState({
        no_polisi: '', nomor_rangka: '', nomor_mesin: '', merek_mtr: '', 
        tipe_mtr: '', tahun_mtr: '', warna_mtr: '', KM_mtr: 0, id_pel: ''
    });
    const navigate = useNavigate();

    const fetchMotor = async () => {
        try {
            const res = await api.get('/motor');
            setMotorList(res.data);
        } catch (error) {
            console.error("Gagal mengambil data motor", error);
        }
    };

    useEffect(() => { fetchMotor(); }, []);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await api.post('/motor', formData);
            alert('Data motor berhasil ditambahkan!');
            fetchMotor();
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal menambahkan motor');
        }
    };

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial' }}>
            <button onClick={() => navigate('/dashboard')}>&larr; Kembali</button>
            <h2>Manajemen Data Motor</h2>
            
            <div style={{ border: '1px solid #ccc', padding: '15px', marginBottom: '20px', maxWidth: '500px' }}>
                <h3>Tambah Motor Baru</h3>
                <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                    <input type="text" name="no_polisi" placeholder="No Polisi (Misal: KH 1234 AB)" onChange={handleChange} required />
                    <input type="text" name="nomor_rangka" placeholder="No Rangka" onChange={handleChange} required />
                    <input type="text" name="nomor_mesin" placeholder="No Mesin" onChange={handleChange} required />
                    <input type="text" name="merek_mtr" placeholder="Merek (Misal: Honda)" onChange={handleChange} required />
                    <input type="text" name="tipe_mtr" placeholder="Tipe (Misal: Vario)" onChange={handleChange} />
                    <input type="number" name="tahun_mtr" placeholder="Tahun" onChange={handleChange} />
                    <input type="number" name="id_pel" placeholder="ID Pemilik (Pelanggan)" onChange={handleChange} required />
                    <button type="submit">Simpan Motor</button>
                </form>
            </div>

            <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse' }}>
                <thead>
                    <tr style={{ background: '#eee' }}>
                        <th>No Polisi</th>
                        <th>Merek / Tipe</th>
                        <th>Pemilik</th>
                        <th>Kategori</th>
                    </tr>
                </thead>
                <tbody>
                    {motorList.map((m) => (
                        <tr key={m.no_polisi}>
                            <td>{m.no_polisi}</td>
                            <td>{m.merek_mtr} {m.tipe_mtr}</td>
                            <td>{m.nama_pel}</td>
                            <td>{m.kategori_pelanggan}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};
export default Motor;