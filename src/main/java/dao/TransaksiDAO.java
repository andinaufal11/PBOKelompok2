//package dao;
//
//import db_connect.DBConnection;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import model.Kamar;
//import model.Penyewa;
//import model.TransaksiSewa;
//
//public class TransaksiDAO {
//
//    // ==========================================
//    // 1. FITUR BOOKING (Create)
//    // ==========================================
//    public boolean buatBooking(TransaksiSewa trans) {
//        Connection conn = DBConnection.getConnection();
//        if (conn == null) return false;
//
//        String sql = "INSERT INTO transaksi_sewa (id_penyewa, id_kamar, tanggal_mulai, durasi_bulan, total_bayar, status_pembayaran) VALUES (?, ?, ?, ?, ?, ?)";
//        
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, trans.getPenyewa().getIdPengguna());
//            ps.setInt(2, trans.getKamar().getIdKamar());
//            ps.setString(3, trans.getTanggalMulai());
//            ps.setInt(4, trans.getDurasiSewa());
//            ps.setDouble(5, trans.getTotalBayar());
//            ps.setString(6, trans.getStatusPembayaran()); 
//            
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        } finally {
//            try { if (conn != null) conn.close(); } catch (Exception e) {}
//        }
//    }
//
//    // ==========================================
//    // 2. FITUR UPDATE STATUS
//    // ==========================================
//    public boolean updateStatus(int idTransaksi, String statusBaru) {
//        String sql = "UPDATE transaksi_sewa SET status_pembayaran = ? WHERE id_transaksi = ?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, statusBaru);
//            ps.setInt(2, idTransaksi);
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // ==========================================
//    // 3. FITUR RIWAYAT (Untuk Penyewa) - SUDAH DIPERBAIKI
//    // ==========================================
//    public List<TransaksiSewa> getRiwayatByPenyewa(int idPenyewa) {
//        List<TransaksiSewa> list = new ArrayList<>();
//        
//        // PERBAIKAN SQL: Menambahkan JOIN ke properti_kos untuk ambil nama_kos
//        String sql = "SELECT t.*, k.nomor_kamar, p.nama_kos " +
//                     "FROM transaksi_sewa t " +
//                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
//                     "JOIN properti_kos p ON k.id_kos = p.id_kos " + 
//                     "WHERE t.id_penyewa = ? ORDER BY t.id_transaksi DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, idPenyewa);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                TransaksiSewa t = mapResultSetToTransaksi(rs);
//                
//                Kamar k = new Kamar();
//                k.setIdKamar(rs.getInt("id_kamar"));
//                k.setNomorKamar(rs.getString("nomor_kamar"));
//                
//                // SET NAMA KOS (Agar tidak error di JSP)
//                k.setNamaKos(rs.getString("nama_kos"));
//                
//                t.setKamar(k);
//                
//                list.add(t);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    // ==========================================
//    // 4. KHUSUS HALAMAN KONFIRMASI (Inbox Permintaan)
//    // ==========================================
//    public List<TransaksiSewa> getPermintaanSewa(int idPemilik) {
//        List<TransaksiSewa> list = new ArrayList<>();
//        String sql = "SELECT t.*, k.nomor_kamar, u.nama_lengkap, u.no_hp " + 
//                     "FROM transaksi_sewa t " +
//                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
//                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +  
//                     "LEFT JOIN penyewa u ON t.id_penyewa = u.id_pengguna " +
//                     "WHERE p.id_pemilik = ? AND t.status_pembayaran = 'Menunggu Konfirmasi' " + 
//                     "ORDER BY t.id_transaksi ASC"; 
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, idPemilik);
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    list.add(mapResultSetToTransaksiFull(rs)); 
//                }
//            }
//        } catch (SQLException e) { e.printStackTrace(); }
//        return list;
//    }
//
//    // ==========================================
//    // 5. KHUSUS HALAMAN LAPORAN (Arsip - Filter By Owner & Status)
//    // ==========================================
//    public List<TransaksiSewa> getAllLaporan(int idPemilik) {
//        List<TransaksiSewa> list = new ArrayList<>();
//        String sql = "SELECT t.*, k.nomor_kamar, u.nama_lengkap, u.no_hp " + 
//                     "FROM transaksi_sewa t " +
//                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
//                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +  
//                     "LEFT JOIN penyewa u ON t.id_penyewa = u.id_pengguna " +
//                     "WHERE p.id_pemilik = ? " +
//                     "AND t.status_pembayaran != 'Menunggu Konfirmasi' " + 
//                     "AND t.status_pembayaran NOT IN ('Dibatalkan', 'Batal') " +
//                     "ORDER BY t.id_transaksi DESC";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, idPemilik);
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    list.add(mapResultSetToTransaksiFull(rs));
//                }
//            }
//        } catch (SQLException e) { e.printStackTrace(); }
//        return list;
//    }
//
//    // ==========================================
//    // 6. STATISTIK (FILTER BY OWNER)
//    // ==========================================
//    public double getTotalPenghasilan(int idPemilik) {
//        String sql = "SELECT SUM(t.total_bayar) FROM transaksi_sewa t " +
//                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
//                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +
//                     "WHERE p.id_pemilik = ? AND t.status_pembayaran IN ('Disetujui', 'Booked', 'Lunas', 'Aktif')"; 
//        
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, idPemilik);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) return rs.getDouble(1);
//        } catch (SQLException e) { e.printStackTrace(); }
//        return 0;
//    }
//
//    public int getJumlahTerisi(int idPemilik) {
//        String sql = "SELECT COUNT(*) FROM kamar k " +
//                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +
//                     "WHERE p.id_pemilik = ? AND k.status_kamar = 'Terisi'";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, idPemilik);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) return rs.getInt(1);
//        } catch (SQLException e) { e.printStackTrace(); }
//        return 0;
//    }
//    
//    public int getTotalKamar(int idPemilik) {
//        String sql = "SELECT COUNT(*) FROM kamar k " +
//                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +
//                     "WHERE p.id_pemilik = ?";
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, idPemilik);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) return rs.getInt(1);
//        } catch (SQLException e) { e.printStackTrace(); }
//        return 0;
//    }
//
//    // ==========================================
//    // HELPER METHODS
//    // ==========================================
//    
//    // Helper Sederhana (Untuk Riwayat Penyewa)
//    private TransaksiSewa mapResultSetToTransaksi(ResultSet rs) throws SQLException {
//        TransaksiSewa t = new TransaksiSewa();
//        t.setIdTransaksi(rs.getInt("id_transaksi"));
//        t.setTanggalMulai(rs.getString("tanggal_mulai"));
//        try { t.setDurasiSewa(rs.getInt("durasi_bulan")); } catch(Exception e) { t.setDurasiSewa(rs.getInt("durasi")); }
//        t.setTotalBayar(rs.getDouble("total_bayar"));
//        t.setStatusPembayaran(rs.getString("status_pembayaran"));
//        return t;
//    }
//
//    // Helper Lengkap (Untuk Laporan & Konfirmasi - Memuat Info Penyewa & Kamar)
//    private TransaksiSewa mapResultSetToTransaksiFull(ResultSet rs) throws SQLException {
//        TransaksiSewa t = new TransaksiSewa();
//        t.setIdTransaksi(rs.getInt("id_transaksi"));
//        t.setTanggalMulai(rs.getString("tanggal_mulai"));
//        try { t.setDurasiSewa(rs.getInt("durasi_bulan")); } catch(Exception e) { t.setDurasiSewa(rs.getInt("durasi")); }
//        t.setTotalBayar(rs.getDouble("total_bayar"));
//        t.setStatusPembayaran(rs.getString("status_pembayaran"));
//
//        // Set Info Kamar
//        Kamar k = new Kamar();
//        k.setIdKamar(rs.getInt("id_kamar"));
//        String noKamar = rs.getString("nomor_kamar");
//        k.setNomorKamar(noKamar != null ? noKamar : "Terhapus");
//        t.setKamar(k);
//
//        // Set Info Penyewa
//        Penyewa p = new Penyewa();
//        String nama = rs.getString("nama_lengkap");
//        String hp = rs.getString("no_hp");
//        p.setNamaPanggilan(nama != null ? nama : "User");
//        p.setNoHp(hp != null ? hp : "-");
//        t.setPenyewa(p);
//        
//        return t;
//    }
//}

package dao;

import db_connect.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Kamar;
import model.Penyewa;
import model.TransaksiSewa;

public class TransaksiDAO {

    // ==========================================
    // 1. FITUR BOOKING (Create)
    // ==========================================
    public boolean buatBooking(TransaksiSewa trans) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        String sql = "INSERT INTO transaksi_sewa (id_penyewa, id_kamar, tanggal_mulai, durasi_bulan, total_bayar, status_pembayaran) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, trans.getPenyewa().getIdPengguna());
            ps.setInt(2, trans.getKamar().getIdKamar());
            ps.setString(3, trans.getTanggalMulai());
            ps.setInt(4, trans.getDurasiSewa());
            ps.setDouble(5, trans.getTotalBayar());
            ps.setString(6, trans.getStatusPembayaran()); 
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // ==========================================
    // 2. FITUR UPDATE STATUS
    // ==========================================
    public boolean updateStatus(int idTransaksi, String statusBaru) {
        String sql = "UPDATE transaksi_sewa SET status_pembayaran = ? WHERE id_transaksi = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusBaru);
            ps.setInt(2, idTransaksi);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // 3. FITUR RIWAYAT (Untuk Penyewa)
    // ==========================================
    public List<TransaksiSewa> getRiwayatByPenyewa(int idPenyewa) {
        List<TransaksiSewa> list = new ArrayList<>();
        
        // QUERY: Join ke properti_kos untuk ambil nama_kos
        String sql = "SELECT t.*, k.nomor_kamar, p.nama_kos " +
                     "FROM transaksi_sewa t " +
                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " + 
                     "WHERE t.id_penyewa = ? ORDER BY t.id_transaksi DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenyewa);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TransaksiSewa t = mapResultSetToTransaksi(rs);
                
                Kamar k = new Kamar();
                k.setIdKamar(rs.getInt("id_kamar"));
                k.setNomorKamar(rs.getString("nomor_kamar"));
                k.setNamaKos(rs.getString("nama_kos")); // Set Nama Kos
                t.setKamar(k);
                
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // 4. KHUSUS HALAMAN KONFIRMASI (Inbox Permintaan)
    // ==========================================
    public List<TransaksiSewa> getPermintaanSewa(int idPemilik) {
        List<TransaksiSewa> list = new ArrayList<>();
        String sql = "SELECT t.*, k.nomor_kamar, u.nama_lengkap, u.no_hp " + 
                     "FROM transaksi_sewa t " +
                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +  
                     "LEFT JOIN penyewa u ON t.id_penyewa = u.id_pengguna " +
                     "WHERE p.id_pemilik = ? AND t.status_pembayaran = 'Menunggu Konfirmasi' " + 
                     "ORDER BY t.id_transaksi ASC"; 

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPemilik);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaksiFull(rs)); 
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==========================================
    // 5. KHUSUS HALAMAN LAPORAN (Arsip - Filter By Owner)
    // ==========================================
    public List<TransaksiSewa> getAllLaporan(int idPemilik) {
        List<TransaksiSewa> list = new ArrayList<>();
        String sql = "SELECT t.*, k.nomor_kamar, u.nama_lengkap, u.no_hp " + 
                     "FROM transaksi_sewa t " +
                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +  
                     "LEFT JOIN penyewa u ON t.id_penyewa = u.id_pengguna " +
                     "WHERE p.id_pemilik = ? " +
                     "AND t.status_pembayaran != 'Menunggu Konfirmasi' " + 
                     "AND t.status_pembayaran NOT IN ('Dibatalkan', 'Batal') " +
                     "ORDER BY t.id_transaksi DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPemilik);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaksiFull(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==========================================
    // 6. STATISTIK (FILTER BY OWNER)
    // ==========================================
    public double getTotalPenghasilan(int idPemilik) {
        String sql = "SELECT SUM(t.total_bayar) FROM transaksi_sewa t " +
                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +
                     "WHERE p.id_pemilik = ? AND t.status_pembayaran IN ('Disetujui', 'Booked', 'Lunas', 'Aktif')"; 
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPemilik);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getJumlahTerisi(int idPemilik) {
        String sql = "SELECT COUNT(*) FROM kamar k " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +
                     "WHERE p.id_pemilik = ? AND k.status_kamar = 'Terisi'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPemilik);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
    
    public int getTotalKamar(int idPemilik) {
        String sql = "SELECT COUNT(*) FROM kamar k " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +
                     "WHERE p.id_pemilik = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPemilik);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ==========================================
    // 7. DATA PENGHUNI AKTIF (YANG HILANG TADI)
    // ==========================================
    public List<TransaksiSewa> getPenghuniAktif(int idPemilik) {
        List<TransaksiSewa> list = new ArrayList<>();
        
        // Query untuk mengambil penghuni yang statusnya Aktif/Lunas/Disetujui
        String sql = "SELECT t.*, k.nomor_kamar, u.nama_lengkap, u.no_hp " + 
                     "FROM transaksi_sewa t " +
                     "JOIN kamar k ON t.id_kamar = k.id_kamar " +
                     "JOIN properti_kos p ON k.id_kos = p.id_kos " +  
                     "JOIN penyewa u ON t.id_penyewa = u.id_pengguna " +
                     "WHERE p.id_pemilik = ? " +
                     "AND t.status_pembayaran IN ('Aktif', 'Disetujui', 'Lunas') " + 
                     "ORDER BY k.nomor_kamar ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idPemilik);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTransaksiFull(rs));
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // ==========================================
    // HELPER METHODS
    // ==========================================
    
    private TransaksiSewa mapResultSetToTransaksi(ResultSet rs) throws SQLException {
        TransaksiSewa t = new TransaksiSewa();
        t.setIdTransaksi(rs.getInt("id_transaksi"));
        t.setTanggalMulai(rs.getString("tanggal_mulai"));
        try { t.setDurasiSewa(rs.getInt("durasi_bulan")); } catch(Exception e) { t.setDurasiSewa(rs.getInt("durasi")); }
        t.setTotalBayar(rs.getDouble("total_bayar"));
        t.setStatusPembayaran(rs.getString("status_pembayaran"));
        return t;
    }

    private TransaksiSewa mapResultSetToTransaksiFull(ResultSet rs) throws SQLException {
        TransaksiSewa t = new TransaksiSewa();
        t.setIdTransaksi(rs.getInt("id_transaksi"));
        t.setTanggalMulai(rs.getString("tanggal_mulai"));
        try { t.setDurasiSewa(rs.getInt("durasi_bulan")); } catch(Exception e) { t.setDurasiSewa(rs.getInt("durasi")); }
        t.setTotalBayar(rs.getDouble("total_bayar"));
        t.setStatusPembayaran(rs.getString("status_pembayaran"));

        // Set Info Kamar
        Kamar k = new Kamar();
        k.setIdKamar(rs.getInt("id_kamar"));
        String noKamar = rs.getString("nomor_kamar");
        k.setNomorKamar(noKamar != null ? noKamar : "Terhapus");
        t.setKamar(k);

        // Set Info Penyewa
        Penyewa p = new Penyewa();
        String nama = rs.getString("nama_lengkap");
        String hp = rs.getString("no_hp");
        p.setNamaPanggilan(nama != null ? nama : "User");
        p.setNoHp(hp != null ? hp : "-");
        t.setPenyewa(p);
        
        return t;
    }
}