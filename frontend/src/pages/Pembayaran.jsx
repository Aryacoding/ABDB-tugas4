// File: src/pages/Pembayaran.jsx
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

const Pembayaran = () => {
    const [noWo, setNoWo] = useState('');
    const [tagihan, setTagihan] = useState(null);
    const [metode, setMetode] = useState('tunai');
    const navigate = useNavigate();

    // Fungsi untuk memanggil Stored Procedure perhitungan tagihan
    const handleCekTagihan = async (e) => {
        e.preventDefault();
        try {
            const res = await api.get(`/pembayaran/tagihan/${noWo}`);
            setTagihan(res.data.total_tagihan);
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal mengecek tagihan');
        }
    };

    // Fungsi untuk mencatat pembayaran
    const handleBayar = async () => {
        try {
            await api.post('/pembayaran', {
                no_wo: noWo,
                total_biaya_akhir: tagihan,
                metode_pembayaran: metode,
                catatan: 'Dibayar lunas'
            });
            alert('Pembayaran berhasil dicatat. Status WO otomatis menjadi Selesai!');
            setTagihan(null);
            setNoWo('');
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal memproses pembayaran');
        }
    };

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial' }}>
            <button onClick={() => navigate('/dashboard')}>&larr; Kembali</button>
            <h2>Kasir - Pembayaran Work Order</h2>

            <form onSubmit={handleCekTagihan} style={{ marginBottom: '20px' }}>
                <input type="text" placeholder="Masukkan No WO (Contoh: WO-1001)" value={noWo} onChange={(e) => setNoWo(e.target.value)} required style={{ marginRight: '10px' }} />
                <button type="submit">Cek Total Tagihan</button>
            </form>

            {tagihan !== null && (
                <div style={{ border: '1px solid green', padding: '15px', maxWidth: '400px' }}>
                    <h3>Total Tagihan: Rp {tagihan}</h3>
                    <div style={{ marginBottom: '10px' }}>
                        <label>Metode Pembayaran: </label>
                        <select value={metode} onChange={(e) => setMetode(e.target.value)}>
                            <option value="tunai">Tunai</option>
                            <option value="transfer">Transfer</option>
                            <option value="qris">QRIS</option>
                            <option value="debit">Debit</option>
                        </select>
                    </div>
                    <button onClick={handleBayar} style={{ background: 'green', color: 'white', padding: '10px' }}>Proses Pembayaran</button>
                </div>
            )}
        </div>
    );
};
export default Pembayaran;