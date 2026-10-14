// File: middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');

// Mengecek apakah user mengirimkan token yang valid
const verifyToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(403).json({ message: 'Token diperlukan, silakan login!' });

    const token = authHeader.split(' ')[1]; // Format: "Bearer <token>"
    
    jwt.verify(token, process.env.JWT_SECRET || 'rahasia_kalawa_123', (err, decoded) => {
        if (err) return res.status(401).json({ message: 'Token tidak valid atau kadaluarsa' });
        req.user = decoded; // Menyimpan data user ke request
        next();
    });
};

// Mengecek apakah role user sesuai dengan yang diizinkan
const checkRole = (roles) => {
    return (req, res, next) => {
        if (!roles.includes(req.user.role)) {
            return res.status(403).json({ message: 'Akses ditolak! Role Anda tidak memiliki izin.' });
        }
        next();
    };
};

module.exports = { verifyToken, checkRole };