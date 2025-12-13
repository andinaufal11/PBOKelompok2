/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

import db_connect.DBConnection;
import model.Penyewa;
import model.PemilikKos;
import model.Pengguna;

public class PenggunaDAO {

    // FITUR 1: REGISTRASI PENYEWA (Simpan ke tabel 'pengguna' lalu 'penyewa')
public boolean registerPenyewa(Penyewa penyewa) {
        Connection conn = DBConnection.getConnection();
        PreparedStatement psPengguna = null;
        PreparedStatement psPenyewa = null;
        boolean isSuccess = false;

        String sqlInduk = "INSERT INTO pengguna (nama_panggilan, email, password, role) VALUES (?, ?, ?, 'PENYEWA')";
        String sqlAnak = "INSERT INTO penyewa (id_pengguna, nama_lengkap, alamat_asal, no_hp) VALUES (?, ?, ?, ?)";

        try {
            conn.setAutoCommit(false); // Mulai Transaksi

            // 1. Insert Induk
            System.out.println("Menyimpan ke Tabel Pengguna...");
            psPengguna = conn.prepareStatement(sqlInduk, Statement.RETURN_GENERATED_KEYS);
            psPengguna.setString(1, penyewa.getNamaPanggilan());
            psPengguna.setString(2, penyewa.getEmail());
            psPengguna.setString(3, penyewa.getPassword());
            int affected = psPengguna.executeUpdate();
            
            if (affected == 0) {
                throw new SQLException("Gagal insert ke tabel Pengguna, tidak ada baris terpengaruh.");
            }

            ResultSet rs = psPengguna.getGeneratedKeys();
            int newId = 0;
            if (rs.next()) {
                newId = rs.getInt(1);
                System.out.println("ID Baru Terbentuk: " + newId);
            } else {
                throw new SQLException("Gagal mengambil ID Pengguna baru.");
            }

            // 2. Insert Anak
            System.out.println("Menyimpan ke Tabel Penyewa (Anak)...");
            System.out.println("Data: ID=" + newId + ", Nama=" + penyewa.getNamaLengkap() + ", Alamat=" + penyewa.getAlamatAsal());
            
            psPenyewa = conn.prepareStatement(sqlAnak);
            psPenyewa.setInt(1, newId);
            psPenyewa.setString(2, penyewa.getNamaLengkap()); // Pastikan ini tidak NULL
            psPenyewa.setString(3, penyewa.getAlamatAsal());
            psPenyewa.setString(4, penyewa.getNoHp());
            psPenyewa.executeUpdate();

            conn.commit(); // Simpan Permanen
            isSuccess = true;
            System.out.println("Transaksi COMMIT Berhasil!");

        } catch (SQLException e) {
            System.err.println("--- ERROR SQL SAAT REGISTER ---");
            e.printStackTrace(); // INI PENTING: Lihat error merah di output
            try {
                if (conn != null) {
                    System.out.println("Melakukan ROLLBACK...");
                    conn.rollback();
                }
            } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            try {
                if (psPengguna != null) psPengguna.close();
                if (psPenyewa != null) psPenyewa.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return isSuccess;
    }

    // FITUR 1: REGISTRASI PEMILIK (Simpan ke tabel 'pengguna' lalu 'pemilik_kos')
    public boolean registerPemilik(PemilikKos pemilik) {
        Connection conn = DBConnection.getConnection();
        PreparedStatement psPengguna = null;
        PreparedStatement psPemilik = null;
        boolean isSuccess = false;

        String sqlInduk = "INSERT INTO pengguna (nama_panggilan, email, password, role) VALUES (?, ?, ?, 'PEMILIK')";
        String sqlAnak = "INSERT INTO pemilik_kos (id_pengguna, no_hp) VALUES (?, ?)";

        try {
            conn.setAutoCommit(false); // Mulai Transaksi

            // 1. Insert Induk
            psPengguna = conn.prepareStatement(sqlInduk, Statement.RETURN_GENERATED_KEYS);
            psPengguna.setString(1, pemilik.getNamaPanggilan());
            psPengguna.setString(2, pemilik.getEmail());
            psPengguna.setString(3, pemilik.getPassword());
            psPengguna.executeUpdate();

            ResultSet rs = psPengguna.getGeneratedKeys();
            int newId = 0;
            if (rs.next()) {
                newId = rs.getInt(1);
            }

            // 2. Insert Anak
            psPemilik = conn.prepareStatement(sqlAnak);
            psPemilik.setInt(1, newId);
            psPemilik.setString(2, pemilik.getNoHp());
            psPemilik.executeUpdate();

            conn.commit(); // Simpan
            isSuccess = true;
            System.out.println("Registrasi Pemilik Berhasil! ID: " + newId);

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            try {
                if (psPengguna != null) psPengguna.close();
                if (psPemilik != null) psPemilik.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
        return isSuccess;
    }
    
    // FITUR LOGIN (Polimorfisme sederhana)
    // Mengembalikan objek Pengguna (Bisa Penyewa atau PemilikKos)
    public Pengguna login(String email, String password) {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Pengguna user = null;

        String sql = "SELECT * FROM pengguna WHERE email = ? AND password = ?";

        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
                int id = rs.getInt("id_pengguna");
                String nama = rs.getString("nama_panggilan");

                if ("PENYEWA".equals(role)) {
                    user = new Penyewa(); // Instansiasi Subclass
                } else {
                    user = new PemilikKos(); // Instansiasi Subclass
                }
                
                user.setIdPengguna(id);
                user.setNamaPanggilan(nama);
                user.setEmail(email);
                user.setRole(role);
                // Note: Untuk detail lengkap (alamat, dll) bisa ditambahkan query JOIN di sini jika perlu
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
             try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return user;
    }
}
