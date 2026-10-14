-- =========================================================================
-- FILE: admin_security.sql
-- DESKRIPSI: Implementasi Hak Akses (Minggu 2) & Keamanan Basis Data (Minggu 3)
-- =========================================================================

USE kalawa_service_tugas3;

-- =========================================================================
-- =========================================================================
-- AWAL TUGAS MINGGU 2: ADMINISTRASI HAK AKSES / RBAC
-- =========================================================================
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. HAPUS ROLE & USER LAMA (Mencegah error saat dieksekusi ulang)
-- -------------------------------------------------------------------------
DROP ROLE IF EXISTS
    'role_owner',
    'role_admin_cabang',
    'role_kasir',
    'role_mekanik',
    'role_petugas_gudang',
    'role_auditor';

DROP USER IF EXISTS
    'user_owner'@'localhost',
    'user_admin_cbg'@'localhost',
    'user_kasir'@'localhost',
    'user_mekanik'@'localhost',
    'user_gudang'@'localhost',
    'user_auditor'@'localhost';
    'user_auditor'@'localhost';
    'auditor'@'localhost', 'auditor'@'%';

-- -------------------------------------------------------------------------
-- 2. BUAT ROLE & USER
-- -------------------------------------------------------------------------
CREATE ROLE
    'role_owner',
    'role_admin_cabang',
    'role_kasir',
    'role_mekanik',
    'role_petugas_gudang',
    'role_auditor';

-- Password diset '1' untuk mempermudah tes/demonstrasi tugas
CREATE USER 'user_owner'@'localhost' IDENTIFIED BY '1';
CREATE USER 'user_admin_cbg'@'localhost' IDENTIFIED BY '1';
CREATE USER 'user_kasir'@'localhost' IDENTIFIED BY '1';
CREATE USER 'user_mekanik'@'localhost' IDENTIFIED BY '1';
CREATE USER 'user_gudang'@'localhost' IDENTIFIED BY '1';
CREATE USER 'auditor'@'localhost' IDENTIFIED BY '1';

-- -------------------------------------------------------------------------
-- 3. GRANT PRIVILEGE KE ROLE (Termasuk EXECUTE)
-- -------------------------------------------------------------------------

-- A. ROLE OWNER (Akses Penuh)
GRANT ALL PRIVILEGES ON kalawa_service_tugas3.* TO 'role_owner';

-- B. ROLE ADMIN CABANG
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.work_order TO 'role_admin_cabang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.wo_mekanik TO 'role_admin_cabang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.wo_jasa TO 'role_admin_cabang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.wo_part TO 'role_admin_cabang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.pelanggan TO 'role_admin_cabang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.motor TO 'role_admin_cabang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.pemesanan_sparepart TO 'role_admin_cabang';
GRANT SELECT ON kalawa_service_tugas3.cabang TO 'role_admin_cabang';
GRANT SELECT ON kalawa_service_tugas3.jasa TO 'role_admin_cabang';
GRANT SELECT ON kalawa_service_tugas3.part TO 'role_admin_cabang';
GRANT SELECT ON kalawa_service_tugas3.pegawai TO 'role_admin_cabang';
-- Penambahan Hak EXECUTE
GRANT EXECUTE ON kalawa_service_tugas3.* TO 'role_admin_cabang';

-- C. ROLE KASIR
GRANT SELECT ON kalawa_service_tugas3.work_order TO 'role_kasir';
GRANT SELECT ON kalawa_service_tugas3.pelanggan TO 'role_kasir';
GRANT SELECT, INSERT ON kalawa_service_tugas3.pembayaran TO 'role_kasir';

-- D. ROLE PETUGAS GUDANG
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.part TO 'role_petugas_gudang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.stok_cabang TO 'role_petugas_gudang';
GRANT SELECT, INSERT, UPDATE, DELETE ON kalawa_service_tugas3.pemasok TO 'role_petugas_gudang';
GRANT SELECT ON kalawa_service_tugas3.wo_part TO 'role_petugas_gudang';

-- E. ROLE MEKANIK
GRANT SELECT ON kalawa_service_tugas3.work_order TO 'role_mekanik';
GRANT UPDATE (status_pekerjaan) ON kalawa_service_tugas3.work_order TO 'role_mekanik';
GRANT SELECT ON kalawa_service_tugas3.wo_mekanik TO 'role_mekanik';
GRANT SELECT ON kalawa_service_tugas3.wo_jasa TO 'role_mekanik';
GRANT SELECT ON kalawa_service_tugas3.wo_part TO 'role_mekanik';
GRANT SELECT ON kalawa_service_tugas3.jasa TO 'role_mekanik';
-- Penambahan Hak EXECUTE
GRANT EXECUTE ON kalawa_service_tugas3.* TO 'role_mekanik';

-- F. ROLE AUDITOR (Akses Read-Only Awal)
GRANT SELECT ON kalawa_service_tugas3.* TO 'role_auditor';

-- -------------------------------------------------------------------------
-- 4. ASSIGN ROLE KE USER & AKTIFKAN DEFAULT ROLE
-- -------------------------------------------------------------------------
GRANT 'role_owner' TO 'user_owner'@'localhost';
GRANT 'role_admin_cabang' TO 'user_admin_cbg'@'localhost';
GRANT 'role_kasir' TO 'user_kasir'@'localhost';
GRANT 'role_mekanik' TO 'user_mekanik'@'localhost';
GRANT 'role_petugas_gudang' TO 'user_gudang'@'localhost';
GRANT 'role_auditor' TO 'user_auditor'@'localhost';

SET DEFAULT ROLE ALL TO
    'user_owner'@'localhost',
    'user_admin_cbg'@'localhost',
    'user_kasir'@'localhost',
    'user_mekanik'@'localhost',
    'user_gudang'@'localhost',
    'user_auditor'@'localhost';

FLUSH PRIVILEGES;

-- -------------------------------------------------------------------------
-- 5. IMPLEMENTASI REVOKE 
-- -------------------------------------------------------------------------
-- Admin cabang tidak boleh menghapus data penting
REVOKE DELETE ON kalawa_service_tugas3.work_order FROM 'role_admin_cabang';
REVOKE DELETE ON kalawa_service_tugas3.pelanggan FROM 'role_admin_cabang';
REVOKE DELETE ON kalawa_service_tugas3.motor FROM 'role_admin_cabang';

-- Petugas gudang tidak boleh menghapus master part dan pemasok
REVOKE DELETE ON kalawa_service_tugas3.part FROM 'role_petugas_gudang';
REVOKE DELETE ON kalawa_service_tugas3.pemasok FROM 'role_petugas_gudang';

FLUSH PRIVILEGES;


-- =========================================================================
-- =========================================================================
-- AWAL TUGAS MINGGU 3: KEAMANAN BASIS DATA
-- =========================================================================
-- =========================================================================

-- -------------------------------------------------------------------------
-- 1. IMPLEMENTASI VIEW & DATA MASKING (Keamanan Data Pelanggan)
-- -------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_pelanggan_terbatas;

CREATE SQL SECURITY DEFINER VIEW vw_pelanggan_terbatas AS
SELECT id_pel, nama_pel, jenis_id 
FROM pelanggan;

DROP VIEW IF EXISTS vw_pelanggan_masked;

CREATE SQL SECURITY DEFINER VIEW vw_pelanggan_masked AS
SELECT 
    id_pel, 
    nama_pel, 
    CASE
        WHEN telp_pel IS NULL OR telp_pel = '' THEN NULL
        WHEN CHAR_LENGTH(telp_pel) <= 6 THEN '******'
        ELSE CONCAT(LEFT(telp_pel, 4), '****', RIGHT(telp_pel, 2))
    END AS nomor_telepon_masked,
    jenis_id
FROM pelanggan;

-- Cabut akses SELECT langsung dari tabel pelanggan untuk auditor, 
-- dan ganti dengan memberikan hak akses ke VIEW yang sudah di-masking.
REVOKE SELECT ON kalawa_service_tugas3.pelanggan FROM 'role_auditor';
GRANT SELECT ON kalawa_service_tugas3.vw_pelanggan_terbatas TO 'role_auditor';
GRANT SELECT ON kalawa_service_tugas3.vw_pelanggan_masked TO 'auditor'@'localhost';

FLUSH PRIVILEGES;

-- -------------------------------------------------------------------------
-- 2. TABEL AUDIT LOG (Mencatat Perubahan Penting)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS audit_log;
CREATE TABLE audit_log (
    id_audit INT NOT NULL AUTO_INCREMENT,
    waktu_audit DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nama_user VARCHAR(100) NOT NULL,
    nama_tabel VARCHAR(100) NOT NULL,
    aksi VARCHAR(20) NOT NULL,
    primary_key_data VARCHAR(100),
    data_lama TEXT,
    data_baru TEXT,
    PRIMARY KEY (id_audit),
    CONSTRAINT chk_audit_aksi CHECK (aksi IN ('INSERT', 'UPDATE', 'DELETE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- -------------------------------------------------------------------------
-- 3. TRIGGER UNTUK AUDIT LOG
-- -------------------------------------------------------------------------

-- Trigger Audit Work Order
DROP TRIGGER IF EXISTS trg_audit_work_order_status;
DELIMITER $$
CREATE TRIGGER trg_audit_work_order_status
AFTER UPDATE ON work_order
FOR EACH ROW
BEGIN
    IF NOT (OLD.status_pekerjaan <=> NEW.status_pekerjaan) THEN
        INSERT INTO audit_log (nama_user, nama_tabel, aksi, primary_key_data, data_lama, data_baru)
        VALUES (
            USER(), 'work_order', 'UPDATE', NEW.no_wo,
            CONCAT('status_pekerjaan=', OLD.status_pekerjaan),
            CONCAT('status_pekerjaan=', NEW.status_pekerjaan)
        );
    END IF;
END$$
DELIMITER ;

-- Trigger Audit Pembayaran
DROP TRIGGER IF EXISTS trg_audit_pembayaran_status;
DELIMITER $$
CREATE TRIGGER trg_audit_pembayaran_status
AFTER UPDATE ON pembayaran
FOR EACH ROW
BEGIN
    IF NOT (OLD.status_pembayaran <=> NEW.status_pembayaran)
       OR NOT (OLD.total_biaya_akhir <=> NEW.total_biaya_akhir)
       OR NOT (OLD.metode_pembayaran <=> NEW.metode_pembayaran) THEN
        INSERT INTO audit_log (nama_user, nama_tabel, aksi, primary_key_data, data_lama, data_baru)
        VALUES (
            USER(), 'pembayaran', 'UPDATE', CAST(NEW.id_pembayaran AS CHAR),
            CONCAT('total=', OLD.total_biaya_akhir, '; metode=', OLD.metode_pembayaran, '; status=', OLD.status_pembayaran),
            CONCAT('total=', NEW.total_biaya_akhir, '; metode=', NEW.metode_pembayaran, '; status=', NEW.status_pembayaran)
        );
    END IF;
END$$
DELIMITER ;

-- -------------------------------------------------------------------------
-- 4. STORED PROCEDURE (Keamanan Operasional Tambahan)
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_update_status_work_order;
DELIMITER $$
CREATE PROCEDURE sp_update_status_work_order (
    IN p_no_wo VARCHAR(20),
    IN p_status_baru VARCHAR(20)
)
SQL SECURITY DEFINER
BEGIN
    IF p_status_baru NOT IN ('antrean', 'proses', 'selesai', 'batal') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status pekerjaan tidak valid';
    END IF;

    UPDATE work_order SET status_pekerjaan = p_status_baru WHERE no_wo = p_no_wo;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nomor work order tidak ditemukan';
    END IF;
END$$
DELIMITER ;

-- =========================================================================
-- AKHIR FILE: admin_security.sql
-- =========================================================================