// File: src/pages/Dashboard.jsx
import { useNavigate } from 'react-router-dom';

const Dashboard = () => {
    const navigate = useNavigate();
    
    // Ambil data user dari Local Storage
    const userString = localStorage.getItem('user');
    const user = userString ? JSON.parse(userString) : null;

    const handleLogout = () => {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        navigate('/');
    };

    if (!user) {
        return <p>Silakan login terlebih dahulu.</p>;
    }

    return (
        <div style={{ padding: '20px', fontFamily: 'Arial' }}>
            <h1>Dashboard</h1>
            <p>Selamat datang, <strong>{user.username}</strong>!</p>
            <p>Role Anda: <strong>{user.role}</strong></p>
            <div style={{ marginTop: '20px', marginBottom: '20px' }}>
                {/* Hanya admin atau kasir yang biasanya mengelola pelanggan */}
                {(user.role === 'admin_cabang' || user.role === 'kasir') && (
                    <button onClick={() => navigate('/pelanggan')} style={{ marginRight: '10px' }}>
                        Kelola Pelanggan
                    </button>
                )}
                
            </div>
            <button onClick={handleLogout}>Logout</button>
            {/* Semua role operasional biasanya bisa melihat WO, tapi hak akses spesifik diatur di dalam komponennya */}
            <br />
            <button onClick={() => navigate('/work-order')} style={{ marginRight: '10px' }}>
                Manajemen Work Order
            </button>
            <br />
            {/* // File: src/pages/Dashboard.jsx (Tambahkan di dalam tag div navigasi) */}
            <button onClick={() => navigate('/laporan')} style={{ marginRight: '10px' }}>
                Lihat Laporan
            </button>
            <button onClick={() => navigate('/Motor')} style={{ marginRight: '10px' }}>
                Manajemen Motor
            </button>
            <br />
            <button onClick={() => setActiveTab('partWO')}>Penggunaan Part per WO</button>
        </div>

        
    );
};

export default Dashboard;