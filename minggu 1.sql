-- =========================================================================
-- INISIALISASI DATABASE KALAWA SERVICE
-- =========================================================================
CREATE DATABASE IF NOT EXISTS kalawa_service_tugas3
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE kalawa_service_tugas3;

-- =========================================================================
-- PHYSICAL DATABASE DESIGN (DDL - PEMBUATAN TABEL)
-- =========================================================================

-- ---------------------------------------------------------
-- DROP TABLE (Mencegah error jika tabel sudah ada)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS garansi;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS wo_part;
DROP TABLE IF EXISTS wo_jasa;
DROP TABLE IF EXISTS wo_mekanik;
DROP TABLE IF EXISTS work_order;
DROP TABLE IF EXISTS pemesanan_sparepart;
DROP TABLE IF EXISTS stok_cabang;
DROP TABLE IF EXISTS riwayat_kepemilikan_motor;
DROP TABLE IF EXISTS mekanik_diperbantukan;
DROP TABLE IF EXISTS mekanik;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS jasa;
DROP TABLE IF EXISTS motor;
DROP TABLE IF EXISTS pelanggan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS pegawai;
DROP TABLE IF EXISTS cabang;

-- ---------------------------------------------------------
-- 1. TABEL CABANG
-- ---------------------------------------------------------
CREATE TABLE cabang (
    kode_cabang VARCHAR(10) NOT NULL,
    nama_cabang VARCHAR(100) NOT NULL,
    alamat TEXT NOT NULL,
    nomor_telepon VARCHAR(20),
    jam_operasional VARCHAR(100),
    kapasitas_slot_servis_per_hari INT NOT NULL DEFAULT 20,
    PRIMARY KEY (kode_cabang),
    CONSTRAINT chk_kapasitas_slot CHECK (`kapasitas_slot_servis_per_hari` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 2. TABEL PEGAWAI
-- ---------------------------------------------------------
CREATE TABLE pegawai (
    id_pegawai INT NOT NULL AUTO_INCREMENT,
    nama_pegawai VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(20),
    alamat TEXT,
    tanggal_mulai_bekerja DATE NOT NULL,
    status_aktif TINYINT NOT NULL DEFAULT 1,
    kode_cabang VARCHAR(10) NOT NULL,
    jenis_pegawai ENUM('mekanik', 'administrasi', 'kasir', 'manager', 'petugas gudang', 'lainnya') NOT NULL,
    PRIMARY KEY (id_pegawai),
    CONSTRAINT fk_pegawai_cabang FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_status_aktif CHECK (`status_aktif` IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 3. TABEL MEKANIK
-- ---------------------------------------------------------
CREATE TABLE mekanik (
    id_mek INT NOT NULL,
    keahlian_mek ENUM('umum', 'injeksi', 'kelistrikan', 'mesin', 'transmisi') NOT NULL,
    PRIMARY KEY (id_mek),
    CONSTRAINT fk_mekanik_pegawai FOREIGN KEY (id_mek) REFERENCES pegawai(id_pegawai) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 4. TABEL MEKANIK DIPERBANTUKAN
-- ---------------------------------------------------------
CREATE TABLE mekanik_diperbantukan (
    id INT NOT NULL AUTO_INCREMENT,
    id_mek INT NOT NULL,
    kode_cabang_tujuan VARCHAR(10) NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE,
    PRIMARY KEY (id),
    CONSTRAINT fk_diperbantukan_mekanik FOREIGN KEY (id_mek) REFERENCES mekanik(id_mek) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_diperbantukan_cabang FOREIGN KEY (kode_cabang_tujuan) REFERENCES cabang(kode_cabang) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tanggal_diperbantukan CHECK (`tanggal_selesai` IS NULL OR `tanggal_selesai` >= `tanggal_mulai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 5. TABEL PELANGGAN
-- ---------------------------------------------------------
CREATE TABLE pelanggan (
    id_pel INT NOT NULL AUTO_INCREMENT,
    nama_pel VARCHAR(100) NOT NULL,
    telp_pel VARCHAR(20),
    alamat_pel TEXT,
    jenis_id VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_pel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 6. TABEL MOTOR
-- ---------------------------------------------------------
CREATE TABLE motor (
    no_polisi VARCHAR(15) NOT NULL,
    nomor_rangka VARCHAR(50) NOT NULL,
    nomor_mesin VARCHAR(50) NOT NULL,
    merek_mtr VARCHAR(50) NOT NULL,
    tipe_mtr VARCHAR(50),
    tahun_mtr YEAR,
    warna_mtr VARCHAR(30),
    KM_mtr INT NOT NULL DEFAULT 0,
    id_pel INT NOT NULL,
    PRIMARY KEY (no_polisi),
    UNIQUE KEY uk_motor_nomor_rangka (nomor_rangka),
    UNIQUE KEY uk_motor_nomor_mesin (nomor_mesin),
    CONSTRAINT fk_motor_pelanggan FOREIGN KEY (id_pel) REFERENCES pelanggan(id_pel) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_kilometer CHECK (`KM_mtr` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 7. TABEL RIWAYAT KEPEMILIKAN MOTOR
-- ---------------------------------------------------------
CREATE TABLE riwayat_kepemilikan_motor (
    id_riwayat INT NOT NULL AUTO_INCREMENT,
    no_polisi VARCHAR(15) NOT NULL,
    id_pel INT NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE,
    PRIMARY KEY (id_riwayat),
    CONSTRAINT fk_riwayat_motor FOREIGN KEY (no_polisi) REFERENCES motor(no_polisi) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_riwayat_pelanggan FOREIGN KEY (id_pel) REFERENCES pelanggan(id_pel) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tanggal_riwayat CHECK (`tanggal_selesai` IS NULL OR `tanggal_selesai` >= `tanggal_mulai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 8. TABEL JASA
-- ---------------------------------------------------------
CREATE TABLE jasa (
    id_jasa INT NOT NULL AUTO_INCREMENT,
    kode_jasa VARCHAR(20) NOT NULL,
    uraian_jasa VARCHAR(100) NOT NULL,
    biaya_jasa DECIMAL(15,2) NOT NULL DEFAULT 0,
    keahlian_mek ENUM('umum', 'injeksi', 'kelistrikan', 'mesin', 'transmisi') NOT NULL,
    PRIMARY KEY (id_jasa),
    UNIQUE KEY uk_jasa_kode (kode_jasa),
    CONSTRAINT chk_harga_standar CHECK (`biaya_jasa` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 9. TABEL PART
-- ---------------------------------------------------------
CREATE TABLE part (
    kode_part VARCHAR(20) NOT NULL,
    nama_part VARCHAR(100) NOT NULL,
    harga_beli DECIMAL(15,2) NOT NULL DEFAULT 0,
    harga_satuan DECIMAL(15,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (kode_part),
    CONSTRAINT chk_harga_beli CHECK (`harga_beli` >= 0),
    CONSTRAINT chk_harga_satuan_part CHECK (`harga_satuan` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 10. TABEL PEMASOK
-- ---------------------------------------------------------
CREATE TABLE pemasok (
    id_pemasok INT NOT NULL AUTO_INCREMENT,
    nama_pemasok VARCHAR(100) NOT NULL,
    alamat TEXT,
    nomor_telepon VARCHAR(20),
    email VARCHAR(100),
    PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 11. TABEL STOK CABANG
-- ---------------------------------------------------------
CREATE TABLE stok_cabang (
    id_stok INT NOT NULL AUTO_INCREMENT,
    kode_cabang VARCHAR(10) NOT NULL,
    kode_part VARCHAR(20) NOT NULL,
    jumlah_stok INT NOT NULL DEFAULT 0,
    stok_minimum INT NOT NULL DEFAULT 5,
    PRIMARY KEY (id_stok),
    UNIQUE KEY uk_stok_cabang_part (kode_cabang, kode_part),
    CONSTRAINT fk_stok_cabang FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_stok_part FOREIGN KEY (kode_part) REFERENCES part(kode_part) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_jumlah_stok CHECK (`jumlah_stok` >= 0),
    CONSTRAINT chk_stok_minimum CHECK (`stok_minimum` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 12. TABEL PEMESANAN SPAREPART
-- ---------------------------------------------------------
CREATE TABLE pemesanan_sparepart (
    id_pemesanan INT NOT NULL AUTO_INCREMENT,
    kode_cabang VARCHAR(10) NOT NULL,
    kode_part VARCHAR(20) NOT NULL,
    id_pemasok INT NOT NULL,
    jumlah_pesan INT NOT NULL,
    tanggal_pesan DATE NOT NULL,
    status_pemesanan ENUM('dipesan', 'dikirim', 'diterima', 'batal') NOT NULL DEFAULT 'dipesan',
    tanggal_diterima DATE,
    PRIMARY KEY (id_pemesanan),
    CONSTRAINT fk_pemesanan_cabang FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pemesanan_part FOREIGN KEY (kode_part) REFERENCES part(kode_part) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pemesanan_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok(id_pemasok) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_jumlah_pesan CHECK (`jumlah_pesan` > 0),
    CONSTRAINT chk_tanggal_diterima CHECK (`tanggal_diterima` IS NULL OR `tanggal_diterima` >= `tanggal_pesan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 13. TABEL WORK ORDER
-- ---------------------------------------------------------
CREATE TABLE work_order (
    no_wo VARCHAR(20) NOT NULL,
    tanggal_masuk DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cabang VARCHAR(10) NOT NULL,
    no_polisi VARCHAR(15) NOT NULL,
    keluhan TEXT,
    estimasi_biaya DECIMAL(15,2) NOT NULL DEFAULT 0,
    status_pekerjaan ENUM('antrean', 'proses', 'selesai', 'batal') NOT NULL DEFAULT 'antrean',
    catatan_garansi TEXT,
    tanggal_selesai DATETIME,
    PRIMARY KEY (no_wo),
    CONSTRAINT fk_wo_cabang FOREIGN KEY (cabang) REFERENCES cabang(kode_cabang) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_wo_motor FOREIGN KEY (no_polisi) REFERENCES motor(no_polisi) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_estimasi_biaya CHECK (`estimasi_biaya` >= 0),
    CONSTRAINT chk_tanggal_selesai CHECK (`tanggal_selesai` IS NULL OR `tanggal_selesai` >= `tanggal_masuk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 14. TABEL WO_MEKANIK
-- ---------------------------------------------------------
CREATE TABLE wo_mekanik (
    no_wo VARCHAR(20) NOT NULL,
    id_mek INT NOT NULL,
    peran_mekanik ENUM('PJ', 'Bantuan') NOT NULL DEFAULT 'PJ',
    PRIMARY KEY (no_wo, id_mek),
    CONSTRAINT fk_wo_mekanik_work_order FOREIGN KEY (no_wo) REFERENCES work_order(no_wo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_wo_mekanik_mekanik FOREIGN KEY (id_mek) REFERENCES mekanik(id_mek) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 15. TABEL WO_JASA
-- ---------------------------------------------------------
CREATE TABLE wo_jasa (
    id_detail INT NOT NULL AUTO_INCREMENT,
    no_wo VARCHAR(20) NOT NULL,
    kode_jasa VARCHAR(20) NOT NULL,
    harga_diterapkan DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id_detail),
    CONSTRAINT fk_wo_jasa_work_order FOREIGN KEY (no_wo) REFERENCES work_order(no_wo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_wo_jasa_jasa FOREIGN KEY (kode_jasa) REFERENCES jasa(kode_jasa) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_harga_diterapkan CHECK (`harga_diterapkan` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 16. TABEL WO_PART
-- ---------------------------------------------------------
CREATE TABLE wo_part (
    id_detail INT NOT NULL AUTO_INCREMENT,
    no_wo VARCHAR(20) NOT NULL,
    kode_part VARCHAR(20) NOT NULL,
    kode_cabang VARCHAR(10) NOT NULL,
    qty_part INT NOT NULL DEFAULT 1,
    harga_satuan_saat_transaksi DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id_detail),
    CONSTRAINT fk_wo_part_work_order FOREIGN KEY (no_wo) REFERENCES work_order(no_wo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_wo_part_part FOREIGN KEY (kode_part) REFERENCES part(kode_part) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_wo_part_cabang FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_qty_part CHECK (`qty_part` > 0),
    CONSTRAINT chk_harga_satuan_wo_part CHECK (`harga_satuan_saat_transaksi` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 17. TABEL PEMBAYARAN
-- ---------------------------------------------------------
CREATE TABLE pembayaran (
    id_pembayaran INT NOT NULL AUTO_INCREMENT,
    no_wo VARCHAR(20) NOT NULL,
    total_biaya_akhir DECIMAL(15,2) NOT NULL,
    metode_pembayaran ENUM('tunai', 'transfer', 'qris', 'debit') NOT NULL,
    tanggal_bayar DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pembayaran ENUM('lunas', 'sebagian', 'belum') NOT NULL DEFAULT 'belum',
    catatan TEXT,
    PRIMARY KEY (id_pembayaran),
    UNIQUE KEY uk_pembayaran_no_wo (no_wo),
    CONSTRAINT fk_pembayaran_wo FOREIGN KEY (no_wo) REFERENCES work_order(no_wo) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_total_biaya CHECK (`total_biaya_akhir` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------
-- 18. TABEL GARANSI (Aturan: 1 WO Memiliki 1 Garansi)
-- ---------------------------------------------------------
CREATE TABLE garansi (
    id_garansi INT NOT NULL AUTO_INCREMENT,
    no_wo VARCHAR(20) NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_berakhir DATE NOT NULL,
    deskripsi_garansi TEXT,
    status_garansi ENUM('aktif', 'selesai', 'batal') NOT NULL DEFAULT 'aktif',
    PRIMARY KEY (id_garansi),
    UNIQUE KEY uk_garansi_no_wo (no_wo),
    CONSTRAINT fk_garansi_work_order FOREIGN KEY (no_wo) REFERENCES work_order(no_wo) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_garansi_tanggal CHECK (`tanggal_berakhir` >= `tanggal_mulai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


