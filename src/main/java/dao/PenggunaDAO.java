package dao;

import java.sql.*;
import db_connect.DBConnection;
import model.Penyewa;
import model.PemilikKos;
import model.Pengguna;

public class PenggunaDAO {

    // Registrasi Penyewa ke 2 tabel (pengguna & penyewa)
    public boolean registerPenyewa(Penyewa penyewa) {
        Connection conn = DBConnection.getConnection();
        PreparedStatement psPengguna = null;
        PreparedStatement psPenyewa = null;
        boolean isSuccess = false;

        try {
            conn.setAutoCommit(false); // Mulai transaksi

            // Insert ke tabel utama
            String sqlInduk = "INSERT INTO pengguna (nama_panggilan, email, password, role) VALUES (?, ?, ?, 'PENYEWA')";
            psPengguna = conn.prepareStatement(sqlInduk, Statement.RETURN_GENERATED_KEYS);
            psPengguna.setString(1, penyewa.getNamaPanggilan());
            psPengguna.setString(2, penyewa.getEmail());
            psPengguna.setString(3, penyewa.getPassword());
            psPengguna.executeUpdate();

            // Ambil ID yang baru dibuat
            ResultSet rs = psPengguna.getGeneratedKeys();
            int newId = rs.next() ? rs.getInt(1) : 0;

            // Insert ke tabel detail penyewa
            String sqlAnak = "INSERT INTO penyewa (id_pengguna, nama_lengkap, alamat_asal, no_hp) VALUES (?, ?, ?, ?)";
            psPenyewa = conn.prepareStatement(sqlAnak);
            psPenyewa.setInt(1, newId);
            psPenyewa.setString(2, penyewa.getNamaLengkap());
            psPenyewa.setString(3, penyewa.getAlamatAsal());
            psPenyewa.setString(4, penyewa.getNoHp());
            psPenyewa.executeUpdate();

            conn.commit(); // Simpan permanen
            isSuccess = true;

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {} // Batal jika error
        } finally {
            closeResources(conn, psPengguna, psPenyewa);
        }
        return isSuccess;
    }

    // Registrasi Pemilik (Logika mirip penyewa)
    public boolean registerPemilik(PemilikKos pemilik) {
        Connection conn = DBConnection.getConnection();
        PreparedStatement psPengguna = null;
        PreparedStatement psPemilik = null;
        boolean isSuccess = false;

        try {
            conn.setAutoCommit(false); 

            // Simpan ke tabel pengguna
            String sqlInduk = "INSERT INTO pengguna (nama_panggilan, email, password, role) VALUES (?, ?, ?, 'PEMILIK')";
            psPengguna = conn.prepareStatement(sqlInduk, Statement.RETURN_GENERATED_KEYS);
            psPengguna.setString(1, pemilik.getNamaPanggilan());
            psPengguna.setString(2, pemilik.getEmail());
            psPengguna.setString(3, pemilik.getPassword());
            psPengguna.executeUpdate();

            ResultSet rs = psPengguna.getGeneratedKeys();
            int newId = rs.next() ? rs.getInt(1) : 0;

            // Simpan ke tabel pemilik_kos
            String sqlAnak = "INSERT INTO pemilik_kos (id_pengguna, no_hp) VALUES (?, ?)";
            psPemilik = conn.prepareStatement(sqlAnak);
            psPemilik.setInt(1, newId);
            psPemilik.setString(2, pemilik.getNoHp());
            psPemilik.executeUpdate();

            conn.commit();
            isSuccess = true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
        } finally {
            closeResources(conn, psPengguna, psPemilik);
        }
        return isSuccess;
    }

    // Fitur Login menggunakan LEFT JOIN 3 tabel
    public Pengguna login(String email, String password) {
        Connection conn = DBConnection.getConnection();
        Pengguna user = null;

        String sql = "SELECT p.*, pk.no_hp AS hp_pemilik, pk.sk_path, " +
                     "py.alamat_asal, py.nama_lengkap, py.no_hp AS hp_penyewa, py.ktp_path " +
                     "FROM pengguna p " +
                     "LEFT JOIN pemilik_kos pk ON p.id_pengguna = pk.id_pengguna " +
                     "LEFT JOIN penyewa py ON p.id_pengguna = py.id_pengguna " +
                     "WHERE p.email = ? AND p.password = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    
                    // Buat objek sesuai role yang login
                    if ("PENYEWA".equalsIgnoreCase(role)) {
                        Penyewa p = new Penyewa();
                        p.setIdPengguna(rs.getInt("id_pengguna"));
                        p.setNamaPanggilan(rs.getString("nama_panggilan"));
                        p.setKtpPath(rs.getString("ktp_path")); 
                        user = p;
                    } else if ("PEMILIK".equalsIgnoreCase(role)) {
                        PemilikKos pk = new PemilikKos();
                        pk.setIdPengguna(rs.getInt("id_pengguna"));
                        pk.setNamaPanggilan(rs.getString("nama_panggilan"));
                        pk.setSkPath(rs.getString("sk_path")); 
                        user = pk;
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    // Update path file SK
    public boolean updateSKPemilik(int idPengguna, String filePath) {
        String sql = "UPDATE pemilik_kos SET sk_path = ? WHERE id_pengguna = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filePath);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // Update path file KTP
    public boolean updateKTPPenyewa(int idPengguna, String filePath) {
        String sql = "UPDATE penyewa SET ktp_path = ? WHERE id_pengguna = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filePath);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // Tutup koneksi dan statement
    private void closeResources(Connection conn, Statement ps1, Statement ps2) {
        try {
            if (ps1 != null) ps1.close();
            if (ps2 != null) ps2.close();
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        } catch (SQLException e) {}
    }
}