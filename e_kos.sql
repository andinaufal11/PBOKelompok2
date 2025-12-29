-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 28, 2025 at 04:20 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `e_kos`
--

-- --------------------------------------------------------

--
-- Table structure for table `kamar`
--

CREATE TABLE `kamar` (
  `id_kamar` int(11) NOT NULL,
  `id_kos` int(11) NOT NULL,
  `nomor_kamar` varchar(10) NOT NULL,
  `tipe_kamar` varchar(20) NOT NULL,
  `fasilitas` text DEFAULT NULL,
  `harga_bulanan` double NOT NULL,
  `status_kamar` varchar(15) DEFAULT 'Tersedia',
  `foto_kamar` varchar(255) DEFAULT 'default_kamar.jpg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kamar`
--

INSERT INTO `kamar` (`id_kamar`, `id_kos`, `nomor_kamar`, `tipe_kamar`, `fasilitas`, `harga_bulanan`, `status_kamar`, `foto_kamar`) VALUES
(13, 11, 'A1', 'Reguler', 'tv, wifi, ac [Ukuran: 3x3 | Kasur: single]', 1000000, 'Terisi', 'b24ec010-49da-44ea-89f2-8ac4257601d6.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `pemilik_kos`
--

CREATE TABLE `pemilik_kos` (
  `id_pengguna` int(11) NOT NULL,
  `no_hp` varchar(20) NOT NULL,
  `sk_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pemilik_kos`
--

INSERT INTO `pemilik_kos` (`id_pengguna`, `no_hp`, `sk_path`) VALUES
(14, '0811547999', 'SK_14_1766924853907.jpg'),
(15, '123', 'SK_15_1766933609215.jpg'),
(16, '123', 'SK_16_1766934100366.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_panggilan` varchar(100) NOT NULL,
  `role` enum('PEMILIK','PENYEWA') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `foto_sk` varchar(255) DEFAULT NULL,
  `status_verifikasi` enum('BELUM','PENDING','VERIFIED') DEFAULT 'BELUM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `email`, `password`, `nama_panggilan`, `role`, `created_at`, `foto_sk`, `status_verifikasi`) VALUES
(14, 'admin@test.com', 'password', 'admin', 'PEMILIK', '2025-12-28 12:26:51', NULL, 'BELUM'),
(15, 'andi@gmail.com', 'andi', 'Andi', 'PEMILIK', '2025-12-28 14:52:42', NULL, 'BELUM'),
(16, 'abiyyu@gmail.com', 'abiyyu', 'Abiyyu', 'PEMILIK', '2025-12-28 15:00:39', NULL, 'BELUM'),
(17, 'rozi@gmail.com', 'rozi', 'rozi', 'PENYEWA', '2025-12-28 15:05:24', NULL, 'BELUM');

-- --------------------------------------------------------

--
-- Table structure for table `penyewa`
--

CREATE TABLE `penyewa` (
  `id_pengguna` int(11) NOT NULL,
  `nama_lengkap` varchar(150) NOT NULL,
  `alamat_asal` text NOT NULL,
  `no_hp` varchar(20) NOT NULL,
  `ktp_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penyewa`
--

INSERT INTO `penyewa` (`id_pengguna`, `nama_lengkap`, `alamat_asal`, `no_hp`, `ktp_path`) VALUES
(17, 'rozi', 'jalan baru', '0384928374', 'KTP_17_1766934400121.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `properti_kos`
--

CREATE TABLE `properti_kos` (
  `id_kos` int(11) NOT NULL,
  `id_pemilik` int(11) NOT NULL,
  `nama_kos` varchar(100) NOT NULL,
  `alamat_kos` text NOT NULL,
  `peraturan` text DEFAULT NULL,
  `foto_kos` varchar(255) DEFAULT 'default_kos.jpg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `properti_kos`
--

INSERT INTO `properti_kos` (`id_kos`, `id_pemilik`, `nama_kos`, `alamat_kos`, `peraturan`, `foto_kos`) VALUES
(11, 16, 'MD 25', 'jl kebangsaan', 'batas kunjungan hanya sampai 22.00', 'dfeac4bb-7d2a-4f83-ab2a-2e7f64a95067.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_sewa`
--

CREATE TABLE `transaksi_sewa` (
  `id_transaksi` int(11) NOT NULL,
  `id_penyewa` int(11) NOT NULL,
  `id_kamar` int(11) NOT NULL,
  `tanggal_mulai` date DEFAULT NULL,
  `durasi_bulan` int(11) DEFAULT NULL,
  `total_bayar` double DEFAULT NULL,
  `status_pembayaran` varchar(50) DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi_sewa`
--

INSERT INTO `transaksi_sewa` (`id_transaksi`, `id_penyewa`, `id_kamar`, `tanggal_mulai`, `durasi_bulan`, `total_bayar`, `status_pembayaran`) VALUES
(13, 17, 13, '2025-12-29', 3, 2850000, 'Disetujui');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`id_kamar`),
  ADD KEY `fk_kamar_kos` (`id_kos`);

--
-- Indexes for table `pemilik_kos`
--
ALTER TABLE `pemilik_kos`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `penyewa`
--
ALTER TABLE `penyewa`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indexes for table `properti_kos`
--
ALTER TABLE `properti_kos`
  ADD PRIMARY KEY (`id_kos`),
  ADD KEY `fk_properti_pemilik` (`id_pemilik`);

--
-- Indexes for table `transaksi_sewa`
--
ALTER TABLE `transaksi_sewa`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `fk_transaksi_penyewa` (`id_penyewa`),
  ADD KEY `fk_transaksi_kamar` (`id_kamar`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kamar`
--
ALTER TABLE `kamar`
  MODIFY `id_kamar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `properti_kos`
--
ALTER TABLE `properti_kos`
  MODIFY `id_kos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `transaksi_sewa`
--
ALTER TABLE `transaksi_sewa`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kamar`
--
ALTER TABLE `kamar`
  ADD CONSTRAINT `fk_kamar_kos` FOREIGN KEY (`id_kos`) REFERENCES `properti_kos` (`id_kos`) ON DELETE CASCADE;

--
-- Constraints for table `pemilik_kos`
--
ALTER TABLE `pemilik_kos`
  ADD CONSTRAINT `fk_pemilik_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `penyewa`
--
ALTER TABLE `penyewa`
  ADD CONSTRAINT `fk_penyewa_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `properti_kos`
--
ALTER TABLE `properti_kos`
  ADD CONSTRAINT `fk_properti_pemilik` FOREIGN KEY (`id_pemilik`) REFERENCES `pemilik_kos` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi_sewa`
--
ALTER TABLE `transaksi_sewa`
  ADD CONSTRAINT `fk_transaksi_kamar` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_transaksi_penyewa` FOREIGN KEY (`id_penyewa`) REFERENCES `pengguna` (`id_pengguna`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
