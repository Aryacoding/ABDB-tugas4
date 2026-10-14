// File: routes/api.js
const express = require('express');
const router = express.Router();

// Import Controllers & Middlewares
const authController = require('../controllers/authController');
const pelangganController = require('../controllers/pelangganController');
const { verifyToken, checkRole } = require('../middlewares/authMiddleware');

// Tambahkan di bagian atas bersama import lainnya:
const motorController = require('../controllers/motorController');
// Tambahkan di bagian import atas:
const jasaController = require('../controllers/jasaController');
const inventoryController = require('../controllers/inventoryController');
// Tambahkan di bagian import atas:
const woController = require('../controllers/woController');

// Tambahkan di bahagian import atas:
const pembayaranController = require('../controllers/pembayaranController');
const laporanController = require('../controllers/laporanController');


// ==========================================
// RUTE AUTHENTICATION (Login)
// ==========================================
router.post('/login', authController.login);

// ==========================================
// RUTE PELANGGAN (Dilindungi Token & Role)
// ==========================================
// Hanya admin_cabang dan kasir yang boleh melihat daftar pelanggan
router.get('/pelanggan', verifyToken, checkRole(['admin_cabang', 'kasir']), pelangganController.getAllPelanggan);

// Hanya admin_cabang yang boleh menambahkan pelanggan baru
router.post('/pelanggan', verifyToken, checkRole(['admin_cabang']), pelangganController.createPelanggan);

// Rute untuk mengupdate data pelanggan (Berdasarkan id_pel)
router.put('/pelanggan/:id', verifyToken, checkRole(['admin_cabang']), pelangganController.updatePelanggan);

// Rute untuk menghapus data pelanggan (Berdasarkan id_pel)
router.delete('/pelanggan/:id', verifyToken, checkRole(['admin_cabang']), pelangganController.deletePelanggan);

// ==========================================
// RUTE MOTOR
// ==========================================
router.get('/motor', verifyToken, checkRole(['admin_cabang', 'kasir', 'mekanik']), motorController.getAllMotor);
router.get('/motor/:no_polisi', verifyToken, motorController.getMotorById);
router.post('/motor', verifyToken, checkRole(['admin_cabang']), motorController.createMotor);
router.put('/motor/:no_polisi', verifyToken, checkRole(['admin_cabang']), motorController.updateMotor);
router.delete('/motor/:no_polisi', verifyToken, checkRole(['admin_cabang']), motorController.deleteMotor);

// ==========================================
// RUTE JASA SERVIS (Dikelola Admin)
// ==========================================
router.get('/jasa', verifyToken, jasaController.getAllJasa);
router.post('/jasa', verifyToken, checkRole(['admin_cabang']), jasaController.createJasa);
router.put('/jasa/:id', verifyToken, checkRole(['admin_cabang']), jasaController.updateJasa);
router.delete('/jasa/:id', verifyToken, checkRole(['admin_cabang']), jasaController.deleteJasa);

// ==========================================
// RUTE INVENTORY (Dikelola Petugas Gudang & Admin)
// ==========================================
router.get('/part', verifyToken, inventoryController.getAllPart);
router.post('/part', verifyToken, checkRole(['petugas_gudang', 'admin_cabang']), inventoryController.createPart);
router.put('/part/:kode_part', verifyToken, checkRole(['petugas_gudang', 'admin_cabang']), inventoryController.updatePart);

router.get('/pemasok', verifyToken, inventoryController.getAllPemasok);
router.post('/pemasok', verifyToken, checkRole(['petugas_gudang', 'admin_cabang']), inventoryController.createPemasok);

// ==========================================
// RUTE WORK ORDER (WO)
// ==========================================
// Semua role bisa melihat daftar WO
router.get('/work-order', verifyToken, woController.getAllWO);

// Admin cabang membuat WO baru saat pendaftaran servis
router.post('/work-order', verifyToken, checkRole(['admin_cabang']), woController.createWO);

// Mekanik dan Admin dapat menambahkan detail jasa dan suku cadang
router.post('/work-order/:no_wo/jasa', verifyToken, checkRole(['admin_cabang', 'mekanik']), woController.addJasaToWO);
router.post('/work-order/:no_wo/part', verifyToken, checkRole(['admin_cabang', 'mekanik']), woController.addPartToWO);

// Mekanik dan Admin dapat mengupdate status pekerjaan (antrean -> proses -> selesai)
router.put('/work-order/:no_wo/status', verifyToken, checkRole(['admin_cabang', 'mekanik']), woController.updateStatusWO);


// ==========================================
// RUTE PEMBAYARAN (Dikelola Kasir)[cite: 4]
// ==========================================
router.get('/pembayaran/tagihan/:no_wo', verifyToken, checkRole(['kasir', 'admin_cabang']), pembayaranController.getTotalTagihan);
router.post('/pembayaran', verifyToken, checkRole(['kasir']), pembayaranController.prosesPembayaran);

// ==========================================
// RUTE LAPORAN (Sesuai arahan tugas poin 1)[cite: 4]
// ==========================================
router.get('/laporan/riwayat-servis/:no_polisi', verifyToken, laporanController.getRiwayatServis);
router.get('/laporan/pendapatan', verifyToken, checkRole(['admin_cabang']), laporanController.getPendapatanCabang);
router.get('/laporan/penggunaan-part/:no_wo', verifyToken, laporanController.getPenggunaanPart);
router.get('/laporan/stok-minimum', verifyToken, checkRole(['petugas_gudang', 'admin_cabang']), laporanController.getStokMinimum);

module.exports = router;