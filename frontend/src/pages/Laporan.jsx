// File: src/pages/Laporan.jsx
import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';

const Laporan = () => {
    const navigate = useNavigate();
    const [activeTab, setActiveTab] = useState('riwayat');

    // State Laporan Riwayat
    const [noPolisi, setNoPolisi] = useState('');
    const [riwayat, setRiwayat] = useState([]);

    // State Laporan Pendapatan
    const [tglMulai, setTglMulai] = useState('');
    const [tglAkhir, setTglAkhir] = useState('');
    const [pendapatan, setPendapatan] = useState([]);

    // State Laporan Stok Minimum
    const [stokMinimum, setStokMinimum] = useState([]);

    // Fetch Riwayat Servis
    const handleCariRiwayat = async (e) => {
        e.preventDefault();
        try {
            const res = await api.get(`/laporan/riwayat-servis/${noPolisi}`);
            // SP di MySQL biasanya me-return array di dalam array (index 0 berisi data baris)
            setRiwayat(Array.isArray(res.data) ? res.data : []);
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal mengambil riwayat servis');
        }
    };

    const handleCariLaporanPart = async (e) => {
    e.preventDefault();
    try {
        const res = await api.get(`/laporan/penggunaan-part/${noWoPart}`);
        setLaporanPart(res.data);
    } catch (error) {
        alert('Gagal mengambil laporan part');
    }
    };

    // Fetch Pendapatan
    const handleCariPendapatan = async (e) => {
        e.preventDefault();
        try {
            const res = await api.get(`/laporan/pendapatan?tgl_mulai=${tglMulai}&tgl_akhir=${tglAkhir}`);
            setPendapatan(res.data);
        } catch (error) {
            alert(error.response?.data?.message || 'Gagal mengambil laporan pendapatan');
        }
    };

    // Fetch Stok Minimum
    const fetchStokMinimum = async () => {
        try {
            const res = await api.get('/laporan/stok-minimum');
            setStokMinimum(res.data);
        } catch (error) {
            console.error('Gagal mengambil laporan stok minimum', error);
        }
    };

    // Otomatis fetch data stok saat tab Stok diklik
    useEffect(() => {
        if (activeTab === 'stok') {
            fetchStokMinimum();
        }
    }, [activeTab]);

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial' }}>
            <button onClick={() => navigate('/dashboard')}>&larr; Kembali ke Dashboard</button>
            <h2>Laporan Bengkel Kalawa Service</h2>

            {/* NAVIGASI TAB */}
            <div style={{ marginBottom: '20px' }}>
                <button onClick={() => setActiveTab('riwayat')} style={{ fontWeight: activeTab === 'riwayat' ? 'bold' : 'normal', marginRight: '5px' }}>Riwayat Servis</button>
                <button onClick={() => setActiveTab('pendapatan')} style={{ fontWeight: activeTab === 'pendapatan' ? 'bold' : 'normal', marginRight: '5px' }}>Pendapatan Cabang</button>
                <button onClick={() => setActiveTab('stok')} style={{ fontWeight: activeTab === 'stok' ? 'bold' : 'normal' }}>Stok Minimum</button>
            </div>

            {/* KONTEN TAB RIWAYAT SERVIS */}
            {activeTab === 'riwayat' && (
                <div>
                    <h3>Riwayat Servis Motor</h3>
                    <form onSubmit={handleCariRiwayat} style={{ marginBottom: '15px' }}>
                        <input type="text" placeholder="Masukkan No Polisi..." value={noPolisi} onChange={(e) => setNoPolisi(e.target.value)} required style={{ marginRight: '10px' }} />
                        <button type="submit">Cari</button>
                    </form>
                    <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr style={{ background: '#eee' }}>
                                <th>No WO</th>
                                <th>Tanggal Masuk</th>
                                <th>No Polisi</th>
                                <th>Keluhan</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {riwayat.map((item, index) => (
                                <tr key={index}>
                                    <td>{item.no_wo}</td>
                                    <td>{new Date(item.tanggal_masuk).toLocaleDateString()}</td>
                                    <td>{item.no_polisi}</td>
                                    <td>{item.keluhan}</td>
                                    <td>{item.status_pekerjaan}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {/* KONTEN TAB PENDAPATAN */}
            {activeTab === 'pendapatan' && (
                <div>
                    <h3>Total Pendapatan per Cabang</h3>
                    <form onSubmit={handleCariPendapatan} style={{ marginBottom: '15px' }}>
                        <input type="date" value={tglMulai} onChange={(e) => setTglMulai(e.target.value)} required style={{ marginRight: '10px' }} />
                        <span style={{ marginRight: '10px' }}>s/d</span>
                        <input type="date" value={tglAkhir} onChange={(e) => setTglAkhir(e.target.value)} required style={{ marginRight: '10px' }} />
                        <button type="submit">Tampilkan</button>
                    </form>
                    <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr style={{ background: '#eee' }}>
                                <th>Kode Cabang</th>
                                <th>Total Pendapatan (Rp)</th>
                            </tr>
                        </thead>
                        <tbody>
                            {pendapatan.map((item, index) => (
                                <tr key={index}>
                                    <td>{item.cabang}</td>
                                    <td>{item.total_pendapatan}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {activeTab === 'partWO' && (
                <div>
                    <h3>Penggunaan Suku Cadang per Work Order</h3>
                    <form onSubmit={handleCariLaporanPart} style={{ marginBottom: '15px' }}>
                        <input type="text" placeholder="Masukkan No WO..." value={noWoPart} onChange={(e) => setNoWoPart(e.target.value)} required style={{ marginRight: '10px' }} />
                        <button type="submit">Tampilkan</button>
                    </form>
                    <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr style={{ background: '#eee' }}>
                                <th>No WO</th>
                                <th>Nama Suku Cadang</th>
                                <th>Qty</th>
                                <th>Harga Transaksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {laporanPart.map((item, index) => (
                                <tr key={index}>
                                    <td>{item.no_wo}</td>
                                    <td>{item.nama_part}</td>
                                    <td>{item.qty_part}</td>
                                    <td>{item.harga_satuan_saat_transaksi}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {/* KONTEN TAB STOK MINIMUM */}
            {activeTab === 'stok' && (
                <div>
                    <h3>Suku Cadang di Bawah Stok Minimum</h3>
                    <table border="1" cellPadding="10" style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                            <tr style={{ background: '#eee' }}>
                                <th>Cabang</th>
                                <th>Nama Part</th>
                                <th>Stok Saat Ini</th>
                                <th>Stok Minimum</th>
                            </tr>
                        </thead>
                        <tbody>
                            {stokMinimum.map((item, index) => (
                                <tr key={index}>
                                    <td>{item.kode_cabang}</td>
                                    <td>{item.nama_part}</td>
                                    <td style={{ color: 'red', fontWeight: 'bold' }}>{item.jumlah_stok}</td>
                                    <td>{item.stok_minimum}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}
        </div>
    );
};

export default Laporan;