// File: config/db.js
const mysql = require('mysql2/promise');
require('dotenv').config();

// Membuat connection pool untuk efisiensi koneksi ke MySQL
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test koneksi
pool.getConnection()
    .then(connection => {
        console.log('✅ Berhasil terhubung ke database Kalawa Service');
        connection.release();
    })
    .catch(err => {
        console.error('❌ Gagal terhubung ke database:', err.message);
    });

module.exports = pool;