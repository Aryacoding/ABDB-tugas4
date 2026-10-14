// File: controllers/authController.js
const jwt = require('jsonwebtoken');

// Simulasi user berdasarkan role (karena tabel pegawai tidak punya password)
const users = [
    { id: 1, username: 'admin', password: '1', role: 'admin_cabang' },
    { id: 2, username: 'kasir', password: '1', role: 'kasir' },
    { id: 3, username: 'mekanik', password: '1', role: 'mekanik' },
    { id: 4, username: 'gudang', password: '1', role: 'petugas_gudang' }
];

const login = (req, res) => {
    const { username, password } = req.body;
    
    // Cari user yang cocok
    const user = users.find(u => u.username === username && u.password === password);

    if (!user) {
        return res.status(401).json({ message: 'Username atau password salah!' });
    }

    // Generate JWT Token
    const token = jwt.sign(
        { id: user.id, username: user.username, role: user.role },
        process.env.JWT_SECRET || 'rahasia_kalawa_123',
        { expiresIn: '8h' }
    );

    res.json({
        message: 'Login berhasil',
        token: token,
        user: { username: user.username, role: user.role }
    });
};

module.exports = { login };