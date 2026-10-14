USE kalawa_service_tugas3;

-- Modifikasi tabel pelanggan yang ada
ALTER TABLE pelanggan
ADD COLUMN kategori_pelanggan ENUM('individu', 'korporat') NOT NULL DEFAULT 'individu',
ADD COLUMN nama_perusahaan VARCHAR(150),
ADD COLUMN plafon_kredit DECIMAL(15,2) DEFAULT 0,
ADD COLUMN sisa_kredit DECIMAL(15,2) DEFAULT 0;

-- Tabel baru untuk penagihan kolektif korporat (Bagian dari requirement)
CREATE TABLE tagihan_kolektif (
    id_tagihan INT NOT NULL AUTO_INCREMENT,
    id_pel INT NOT NULL,
    bulan INT NOT NULL,
    tahun INT NOT NULL,
    total_tagihan DECIMAL(15,2) NOT NULL DEFAULT 0,
    status_pembayaran ENUM('belum', 'lunas') NOT NULL DEFAULT 'belum',
    jatuh_tempo DATE NOT NULL,
    PRIMARY KEY (id_tagihan),
    CONSTRAINT fk_tagihan_pelanggan FOREIGN KEY (id_pel) REFERENCES pelanggan(id_pel) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- perbaikan 
USE kalawa_service_tugas3;

-- 1. Hapus trigger insert yang lama
DROP TRIGGER IF EXISTS trg_cegah_tanggal_wo_future_insert;

-- 2. Buat ulang trigger insert yang benar
DELIMITER $$
CREATE TRIGGER trg_cegah_tanggal_wo_future_insert
BEFORE INSERT ON work_order
FOR EACH ROW
BEGIN
    -- Gunakan fungsi DATE() agar DATETIME diubah menjadi DATE saja untuk dibandingkan
    IF DATE(NEW.tanggal_masuk) > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Tanggal Work Order tidak boleh melebihi hari ini.';
    END IF;
END$$
DELIMITER ;

-- 3. Hapus trigger update yang lama
DROP TRIGGER IF EXISTS trg_cegah_tanggal_wo_future_update;

-- 4. Buat ulang trigger update yang benar
DELIMITER $$    
CREATE TRIGGER trg_cegah_tanggal_wo_future_update
BEFORE UPDATE ON work_order
FOR EACH ROW
BEGIN
    IF DATE(NEW.tanggal_masuk) > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Tanggal Work Order tidak boleh melebihi hari ini.';
    END IF;
END$$
DELIMITER ;