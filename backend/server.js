// File: server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const apiRoutes = require('./routes/api');

const app = express();

// Middleware
app.use(cors()); // Mengizinkan request dari Frontend
app.use(express.json()); // Mem-parsing body request dalam format JSON
app.use(express.urlencoded({ extended: true }));

// Memanggil routes
app.get('/', (req, res) => {
    res.send('Server Kalawa Service berjalan! Akses /api untuk endpoint.');
});
app.use('/api', apiRoutes);

// Menjalankan Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server backend berjalan di http://localhost:${PORT}`);
});