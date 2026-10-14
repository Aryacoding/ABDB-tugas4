-- =========================================================================
-- DATA DUMMY (INSERT DATA)
-- =========================================================================

-- ---------------------------------------------------------
-- 1. INSERT CABANG
-- ---------------------------------------------------------
INSERT INTO cabang (kode_cabang, nama_cabang, alamat, nomor_telepon, jam_operasional, kapasitas_slot_servis_per_hari) VALUES
('CBG01', 'Kalawa Pusat Banjarmasin', 'Jl. Hasan Basri No. 1, Banjarmasin', '081100001111', '08:00 - 17:00', 20),
('CBG02', 'Kalawa Cabang Banjarbaru', 'Jl. A. Yani Km. 33, Banjarbaru', '081100002222', '08:00 - 17:00', 15),
('CBG03', 'Kalawa Cabang Martapura', 'Jl. Batuah No. 10, Martapura', '081100003333', '08:00 - 17:00', 10);

-- ---------------------------------------------------------
-- 2. INSERT PEGAWAI
-- ---------------------------------------------------------
INSERT INTO pegawai (id_pegawai, nama_pegawai, nomor_telepon, alamat, tanggal_mulai_bekerja, status_aktif, kode_cabang, jenis_pegawai) VALUES
(1, 'Ahmad (Mekanik Umum)', '081234560001', 'Banjarmasin', '2020-01-10', 1, 'CBG01', 'mekanik'),
(2, 'Budi (Mekanik Spesialis Mesin)', '081234560002', 'Banjarmasin', '2020-02-15', 1, 'CBG01', 'mekanik'),
(3, 'Citra (Kasir)', '081234560003', 'Banjarmasin', '2021-03-20', 1, 'CBG01', 'kasir'),
(4, 'Deni (Admin)', '081234560004', 'Banjarbaru', '2021-04-10', 1, 'CBG01', 'administrasi'),
(5, 'Eko (Petugas Gudang)', '081234560005', 'Banjarmasin', '2021-05-12', 1, 'CBG01', 'petugas gudang'),
(6, 'Fahmi (Mekanik Spesialis Listrik)', '081234560006', 'Banjarbaru', '2022-01-20', 1, 'CBG02', 'mekanik'),
(7, 'Gita (Kasir)', '081234560007', 'Martapura', '2022-02-10', 1, 'CBG02', 'kasir'),
(8, 'Hendra (Mekanik Umum)', '081234560008', 'Martapura', '2023-01-15', 1, 'CBG03', 'mekanik');

-- ---------------------------------------------------------
-- 3. INSERT MEKANIK
-- ---------------------------------------------------------
INSERT INTO mekanik (id_mek, keahlian_mek) VALUES
(1, 'umum'),
(2, 'mesin'),
(6, 'kelistrikan'),
(8, 'umum');

-- ---------------------------------------------------------
-- 4. INSERT PELANGGAN
-- ---------------------------------------------------------
INSERT INTO pelanggan (id_pel, nama_pel, telp_pel, alamat_pel, jenis_id) VALUES
(1, 'Iwan', '085200001111', 'Jl. Pramuka, Banjarmasin', 'KTP'),
(2, 'Joko', '085200002222', 'Jl. Veteran, Banjarmasin', 'KTP'),
(3, 'Kiki', '085200003333', 'Jl. Manggis, Banjarbaru', 'SIM'),
(4, 'Lestari', '085200004444', 'Jl. Karang Anyar, Banjarbaru', 'KTP'),
(5, 'Maman', '085200005555', 'Jl. Sekumpul, Martapura', 'KTP'),
(6, 'Nia', '085200006666', 'Jl. Melati, Martapura', 'SIM');

-- ---------------------------------------------------------
-- 5. INSERT MOTOR
-- ---------------------------------------------------------
INSERT INTO motor (no_polisi, nomor_rangka, nomor_mesin, merek_mtr, tipe_mtr, tahun_mtr, warna_mtr, KM_mtr, id_pel) VALUES
('DA 1111 AA', 'MH1JM111111', 'JM11E11111', 'Honda', 'Vario 150', 2018, 'Hitam', 15000, 1),
('DA 2222 BB', 'MH1JM222222', 'JM11E22222', 'Yamaha', 'NMAX', 2020, 'Putih', 12000, 1),
('DA 3333 CC', 'MH1JM333333', 'JM11E33333', 'Honda', 'Beat', 2019, 'Merah', 20000, 2),
('DA 4444 DD', 'MH1JM444444', 'JM11E44444', 'Suzuki', 'Nex II', 2021, 'Biru', 8000, 2),
('DA 5555 EE', 'MH1JM555555', 'JM11E55555', 'Honda', 'Scoopy', 2022, 'Coklat', 5000, 3),
('DA 6666 FF', 'MH1JM666666', 'JM11E66666', 'Yamaha', 'Aerox', 2019, 'Kuning', 18000, 3),
('DA 7777 GG', 'MH1JM777777', 'JM11E77777', 'Honda', 'PCX', 2021, 'Hitam', 10000, 4),
('DA 8888 HH', 'MH1JM888888', 'JM11E88888', 'Yamaha', 'Mio M3', 2017, 'Merah', 25000, 4),
('DA 9999 II', 'MH1JM999999', 'JM11E99999', 'Honda', 'CBR 150R', 2020, 'Merah', 14000, 5),
('DA 1010 JJ', 'MH1JM000000', 'JM11E00000', 'Kawasaki', 'Ninja 250', 2021, 'Hijau', 6000, 6);

-- ---------------------------------------------------------
-- 6. INSERT JASA
-- ---------------------------------------------------------
INSERT INTO jasa (kode_jasa, uraian_jasa, biaya_jasa, keahlian_mek) VALUES
('SRV-01', 'Servis Ringan / Berkala', 50000, 'umum'),
('SRV-02', 'Ganti Oli Mesin', 15000, 'umum'),
('SRV-03', 'Ganti Oli Gardan', 10000, 'umum'),
('SRV-04', 'Servis Injeksi / Throttle Body', 75000, 'injeksi'),
('SRV-05', 'Turun Mesin (Overhaul)', 350000, 'mesin'),
('SRV-06', 'Ganti Kampas Rem', 25000, 'umum'),
('SRV-07', 'Perbaikan Kelistrikan / Lampu', 60000, 'kelistrikan'),
('SRV-08', 'Ganti Aki / Accu', 20000, 'kelistrikan'),
('SRV-09', 'Servis CVT', 60000, 'transmisi'),
('SRV-10', 'Ganti Komstir', 120000, 'umum');

-- ---------------------------------------------------------
-- 7. INSERT SUKU CADANG / PART
-- ---------------------------------------------------------
INSERT INTO part (kode_part, nama_part, harga_beli, harga_satuan) VALUES
('PRT-01', 'Oli Mesin MPX 1', 40000, 55000),
('PRT-02', 'Oli Mesin MPX 2', 45000, 60000),
('PRT-03', 'Oli Gardan', 15000, 20000),
('PRT-04', 'Busi NGK', 12000, 18000),
('PRT-05', 'Kampas Rem Depan', 35000, 50000),
('PRT-06', 'Kampas Rem Belakang', 30000, 45000),
('PRT-07', 'V-Belt Vario', 110000, 145000),
('PRT-08', 'V-Belt NMAX', 130000, 165000),
('PRT-09', 'Roller Set CVT', 45000, 65000),
('PRT-10', 'Aki GS Astra', 220000, 260000),
('PRT-11', 'Filter Udara Vario', 35000, 48000),
('PRT-12', 'Filter Udara Beat', 30000, 42000),
('PRT-13', 'Bohlam Lampu Utama', 20000, 30000),
('PRT-14', 'Komstir Set', 80000, 110000),
('PRT-15', 'Cairan Injektor Cleaner', 25000, 35000);

-- ---------------------------------------------------------
-- 8. INSERT STOK CABANG
-- ---------------------------------------------------------
INSERT INTO stok_cabang (kode_cabang, kode_part, jumlah_stok, stok_minimum) VALUES
('CBG01', 'PRT-01', 50, 10), ('CBG01', 'PRT-02', 50, 10), ('CBG01', 'PRT-03', 50, 10),
('CBG01', 'PRT-04', 30, 5),  ('CBG01', 'PRT-05', 40, 10), ('CBG01', 'PRT-06', 40, 10),
('CBG01', 'PRT-07', 20, 5),  ('CBG01', 'PRT-10', 15, 3),  ('CBG01', 'PRT-11', 25, 5);

-- ---------------------------------------------------------
-- 9. INSERT SUPPLIER
-- ---------------------------------------------------------
INSERT INTO pemasok (nama_pemasok, alamat, nomor_telepon, email) VALUES
('PT. Astra Honda Motor', 'Jakarta', '021111111', 'ahm@astra.co.id'),
('PT. Yamaha Indonesia', 'Jakarta', '021222222', 'yimm@yamaha.co.id'),
('CV. Makmur Motor', 'Banjarmasin', '0851000111', 'makmur@gmail.com'),
('Toko Maju Jaya Part', 'Banjarbaru', '0851000222', 'majujaya@gmail.com'),
('GS Battery Distributor', 'Banjarmasin', '0851000333', 'gs@battery.co.id');

-- ---------------------------------------------------------
-- 10. INSERT WORK ORDER
-- ---------------------------------------------------------
INSERT INTO work_order (no_wo, tanggal_masuk, cabang, no_polisi, keluhan, status_pekerjaan, tanggal_selesai) VALUES
('WO-001', '2026-09-01 09:00:00', 'CBG01', 'DA 1111 AA', 'Mesin brebet dan rem blong', 'selesai', '2026-09-01 14:00:00'),
('WO-002', '2026-09-05 10:00:00', 'CBG01', 'DA 2222 BB', 'Kelistrikan mati total, lampu redup', 'selesai', '2026-09-05 13:00:00'),
('WO-003', '2026-09-10 08:30:00', 'CBG01', 'DA 3333 CC', 'Servis berkala dan ganti oli', 'selesai', '2026-09-10 10:00:00'),
('WO-004', '2026-09-15 11:00:00', 'CBG01', 'DA 4444 DD', 'CVT getar', 'selesai', '2026-09-15 12:30:00'),
('WO-005', '2026-09-20 14:00:00', 'CBG01', 'DA 5555 EE', 'Ganti ban dan rem', 'selesai', '2026-09-20 15:30:00'),
('WO-006', '2026-09-25 09:00:00', 'CBG01', 'DA 6666 FF', 'Turun mesin, suara kasar', 'proses', NULL),
('WO-007', '2026-09-26 10:00:00', 'CBG01', 'DA 7777 GG', 'Aki tekor terus', 'antrean', NULL),
('WO-008', '2026-09-27 13:00:00', 'CBG01', 'DA 8888 HH', 'Ganti oli rutin', 'antrean', NULL),
('WO-009', '2026-09-26 12:00:00', 'CBG01', 'DA 7777 GG', 'Ganti ban dan rem', 'antrean', NULL),
('WO-010', '2026-09-27 19:00:00', 'CBG01', 'DA 8888 HH', 'Mesin brebet dan rem blong', 'antrean', NULL);

-- ---------------------------------------------------------
-- 11. INSERT WO MEKANIK
-- ---------------------------------------------------------
INSERT INTO wo_mekanik (no_wo, id_mek, peran_mekanik) VALUES
('WO-001', 1, 'PJ'), 
('WO-001', 2, 'Bantuan'),
('WO-002', 1, 'PJ'),
('WO-002', 6, 'Bantuan'),
('WO-003', 1, 'PJ'),
('WO-004', 1, 'PJ'),
('WO-005', 1, 'PJ'),
('WO-006', 2, 'PJ'),
('WO-007', 6, 'PJ'),
('WO-008', 1, 'PJ');

-- ---------------------------------------------------------
-- 12. INSERT DETAIL JASA WO
-- ---------------------------------------------------------
INSERT INTO wo_jasa (no_wo, kode_jasa, harga_diterapkan) VALUES
('WO-001', 'SRV-04', 75000), ('WO-001', 'SRV-06', 25000), 
('WO-002', 'SRV-07', 60000), ('WO-002', 'SRV-08', 20000),
('WO-003', 'SRV-01', 50000), ('WO-003', 'SRV-02', 15000),
('WO-004', 'SRV-09', 60000), ('WO-004', 'SRV-03', 10000),
('WO-005', 'SRV-06', 25000), ('WO-006', 'SRV-05', 350000),
('WO-007', 'SRV-08', 20000), ('WO-008', 'SRV-02', 15000);

-- ---------------------------------------------------------
-- 13. INSERT DETAIL SUKU CADANG WO
-- ---------------------------------------------------------
INSERT INTO wo_part (no_wo, kode_part, kode_cabang, qty_part, harga_satuan_saat_transaksi) VALUES
('WO-001', 'PRT-15', 'CBG01', 1, 35000), ('WO-001', 'PRT-05', 'CBG01', 1, 50000),
('WO-002', 'PRT-13', 'CBG01', 1, 30000), ('WO-002', 'PRT-10', 'CBG01', 1, 260000),
('WO-003', 'PRT-01', 'CBG01', 1, 55000), ('WO-003', 'PRT-03', 'CBG01', 1, 20000),
('WO-004', 'PRT-07', 'CBG01', 1, 145000),('WO-004', 'PRT-09', 'CBG01', 1, 65000),
('WO-005', 'PRT-06', 'CBG01', 1, 45000), ('WO-006', 'PRT-01', 'CBG01', 2, 55000),
('WO-007', 'PRT-10', 'CBG01', 1, 260000),('WO-008', 'PRT-02', 'CBG01', 1, 60000);

-- ---------------------------------------------------------
-- 14. INSERT PEMBAYARAN
-- ---------------------------------------------------------
INSERT INTO pembayaran (no_wo, total_biaya_akhir, metode_pembayaran, tanggal_bayar, status_pembayaran) VALUES
('WO-001', 185000, 'tunai', '2026-09-01 14:15:00', 'lunas'),
('WO-002', 370000, 'qris', '2026-09-05 13:10:00', 'lunas'),
('WO-003', 140000, 'tunai', '2026-09-10 10:15:00', 'lunas'),
('WO-004', 280000, 'debit', '2026-09-15 12:40:00', 'lunas'),
('WO-005', 70000,  'tunai', '2026-09-20 15:35:00', 'lunas'),
('WO-006', 460000, 'transfer', '2026-09-25 09:30:00', 'belum'),
('WO-007', 280000, 'tunai', '2026-09-26 10:05:00', 'belum'),
('WO-008', 75000,  'tunai', '2026-09-27 13:05:00', 'belum');

-- ---------------------------------------------------------
-- 15. INSERT GARANSI PEKERJAAN (Setiap WO Punya Garansi)
-- ---------------------------------------------------------
INSERT INTO garansi (no_wo, tanggal_mulai, tanggal_berakhir, deskripsi_garansi, status_garansi) VALUES
('WO-001', '2026-09-01', '2026-09-08', 'Garansi servis injeksi dan rem', 'selesai'),
('WO-002', '2026-09-05', '2026-09-19', 'Garansi sistem kelistrikan dan accu', 'aktif'),
('WO-003', '2026-09-10', '2026-09-17', 'Garansi servis berkala', 'aktif'),
('WO-004', '2026-09-15', '2026-09-22', 'Garansi pemasangan CVT dan v-belt', 'aktif'),
('WO-005', '2026-09-20', '2026-09-27', 'Garansi ganti ban dan rem', 'aktif'),
('WO-006', '2026-09-25', '2026-10-09', 'Garansi turun mesin (overhaul)', 'aktif'),
('WO-007', '2026-09-26', '2026-10-10', 'Garansi penggantian aki baru', 'aktif'),
('WO-008', '2026-09-27', '2026-10-04', 'Garansi penggantian oli rutin', 'aktif');