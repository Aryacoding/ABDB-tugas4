-- =========================================================================
-- FILE: minggu4_objects.sql
-- DESKRIPSI: Implementasi Stored Procedure, Function, dan Trigger (Minggu 4)
-- =========================================================================

USE kalawa_service_tugas3;

-- =========================================================================
-- 1. TRIGGER
-- =========================================================================

-- A. Trigger untuk mencegah tanggal work order lebih besar dari tanggal saat ini (Insert)
DROP TRIGGER IF EXISTS trg_cegah_tanggal_wo_future_insert;
DELIMITER $$
CREATE TRIGGER trg_cegah_tanggal_wo_future_insert
BEFORE INSERT ON work_order
FOR EACH ROW
BEGIN
    -- Menggunakan tanggal_masuk menyesuaikan struktur tabel
    IF NEW.tanggal_masuk > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Tanggal Work Order tidak boleh melebihi hari ini.';
    END IF;
END$$
DELIMITER ;

-- Trigger untuk mencegah tanggal work order lebih besar dari tanggal saat ini (Update)
DROP TRIGGER IF EXISTS trg_cegah_tanggal_wo_future_update;
DELIMITER $$    
CREATE TRIGGER trg_cegah_tanggal_wo_future_update
BEFORE UPDATE ON work_order
FOR EACH ROW
BEGIN
    IF NEW.tanggal_masuk > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Tanggal Work Order tidak boleh melebihi hari ini.';
    END IF;
END$$
DELIMITER ;

-- B. Trigger untuk mengurangi stok suku cadang saat detail suku cadang work order ditambahkan
DROP TRIGGER IF EXISTS trg_kurangi_stok_part;
DELIMITER $$
CREATE TRIGGER trg_kurangi_stok_part
AFTER INSERT ON wo_part
FOR EACH ROW
BEGIN
    -- Mengurangi jumlah_stok pada tabel stok_cabang
    UPDATE stok_cabang 
    SET jumlah_stok = jumlah_stok - NEW.qty_part
    WHERE kode_part = NEW.kode_part AND kode_cabang = NEW.kode_cabang;
END$$
DELIMITER ;

-- C. Trigger Audit
DELIMITER $$

DROP TRIGGER IF EXISTS trg_audit_work_order_update$$

CREATE TRIGGER trg_audit_work_order_update
AFTER UPDATE ON work_order
FOR EACH ROW
BEGIN
    -- Mengecek apakah ada perubahan pada status pekerjaan
    IF OLD.status_pekerjaan != NEW.status_pekerjaan THEN
        INSERT INTO audit_log (waktu_audit, nama_user, nama_tabel, aksi, data_lama, data_baru)
        VALUES (
            NOW(),
            CURRENT_USER(),
            'work_order',
            'UPDATE',
            CONCAT('Status Lama: ', OLD.status_pekerjaan),
            CONCAT('Status Baru: ', NEW.status_pekerjaan)
        );
    END IF;
END$$

DELIMITER ;

-- =========================================================================
-- 2. STORED PROCEDURE
-- =========================================================================

-- A. Stored procedure untuk menampilkan riwayat servis berdasarkan nomor polisi
DROP PROCEDURE IF EXISTS sp_riwayat_servis_nopol;
DELIMITER $$
CREATE PROCEDURE sp_riwayat_servis_nopol(
    IN p_nopol VARCHAR(20)
)
BEGIN
    SELECT 
        no_wo, 
        tanggal_masuk, 
        no_polisi, 
        keluhan, 
        status_pekerjaan
    FROM work_order
    WHERE no_polisi = p_nopol
    ORDER BY tanggal_masuk DESC;
END$$
DELIMITER ;

-- B. Stored procedure untuk menampilkan daftar work order berdasarkan rentang tanggal dan cabang
DROP PROCEDURE IF EXISTS sp_list_wo_tanggal_cabang;
DELIMITER $$
CREATE PROCEDURE sp_list_wo_tanggal_cabang(
    IN p_tgl_mulai DATE,
    IN p_tgl_akhir DATE,
    IN p_kode_cabang VARCHAR(20)
)
BEGIN
    SELECT 
        no_wo, 
        tanggal_masuk, 
        no_polisi, 
        keluhan, 
        status_pekerjaan 
    FROM work_order
    WHERE cabang = p_kode_cabang 
      AND tanggal_masuk BETWEEN p_tgl_mulai AND p_tgl_akhir
    ORDER BY tanggal_masuk ASC;
END$$
DELIMITER ;

-- C. Stored procedure untuk menghitung total tagihan work order dari jasa dan suku cadang
DROP PROCEDURE IF EXISTS sp_hitung_total_tagihan_wo$$
DELIMITER $$
CREATE PROCEDURE sp_hitung_total_tagihan_wo(
    IN p_no_wo VARCHAR(50),
    OUT p_total_tagihan DECIMAL(10,2)
)
BEGIN
    DECLARE total_jasa DECIMAL(10,2) DEFAULT 0;
    DECLARE total_part DECIMAL(10,2) DEFAULT 0;

    -- Menghitung total biaya dari tabel wo_jasa menggunakan 'harga_diterapkan'
    SELECT IFNULL(SUM(harga_diterapkan), 0) INTO total_jasa
    FROM wo_jasa
    WHERE no_wo = p_no_wo;

    -- Menghitung total biaya dari tabel wo_part
    SELECT IFNULL(SUM(qty_part * harga_satuan_saat_transaksi), 0) INTO total_part
    FROM wo_part
    WHERE no_wo = p_no_wo;

    -- Menjumlahkan keduanya
    SET p_total_tagihan = total_jasa + total_part;
END$$

DELIMITER ;

-- =========================================================================
-- 3. FUNCTION
-- =========================================================================

-- A. Function untuk menghitung status garansi 
DROP FUNCTION IF EXISTS fn_cek_status_garansi;
DELIMITER $$
CREATE FUNCTION fn_cek_status_garansi(
    p_tanggal_selesai DATE,
    p_hari_garansi INT
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_batas_garansi DATE;
    DECLARE v_status VARCHAR(20);
    
    IF p_tanggal_selesai IS NULL THEN
        RETURN 'Servis Belum Selesai';
    END IF;
    
    SET v_batas_garansi = DATE_ADD(p_tanggal_selesai, INTERVAL p_hari_garansi DAY);
    
    IF CURDATE() <= v_batas_garansi THEN
        SET v_status = 'Garansi Aktif';
    ELSE
        SET v_status = 'Garansi Kedaluwarsa';
    END IF;
    
    RETURN v_status;
END$$
DELIMITER ;