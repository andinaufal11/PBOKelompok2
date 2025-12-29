/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import db_connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Kamar;
import model.KamarEksklusif;
import model.KamarReguler;
/**
 *
 * @author Fachrul Rozi
 */

public class KamarDAO {

    // 1. TAMBAH KAMAR BARU
    public boolean tambahKamar(Kamar k) {
        // UPDATE SQL: Menambahkan kolom foto_kamar
        String sql = "INSERT INTO kamar (id_kos, nomor_kamar, tipe_kamar, fasilitas, harga_bulanan, status_kamar, foto_kamar) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, k.getIdKos());
            ps.setString(2, k.getNomorKamar());
            ps.setString(3, k.getTipeSpesifik());
            ps.setString(4, k.getFasilitas());
            ps.setDouble(5, k.getHargaBulanan());
            ps.setString(6, "Tersedia");
            ps.setString(7, k.getFotoKamar()); // Parameter ke-7 untuk Foto
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. AMBIL SEMUA KAMAR (Untuk Tampil di Tabel)
    public List<Kamar> getKamarByKos(int idKos) {
        List<Kamar> list = new ArrayList<>();
        String sql = "SELECT * FROM kamar WHERE id_kos = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idKos);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String tipeDB = rs.getString("tipe_kamar");
                Kamar k;
                
                // Logika Polimorfisme saat mengambil data
                if ("VIP".equalsIgnoreCase(tipeDB) || "Eksklusif".equalsIgnoreCase(tipeDB)) {
                    k = new KamarEksklusif();
                } else {
                    k = new KamarReguler();
                }
                
                k.setIdKamar(rs.getInt("id_kamar"));
                k.setIdKos(rs.getInt("id_kos"));
                k.setNomorKamar(rs.getString("nomor_kamar"));
                k.setFasilitas(rs.getString("fasilitas"));
                k.setHargaBulanan(rs.getDouble("harga_bulanan"));
                k.setStatusKamar(rs.getString("status_kamar"));
                k.setFotoKamar(rs.getString("foto_kamar")); // Ambil foto kamar dari DB
                
                list.add(k);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. HAPUS KAMAR
    public boolean hapusKamar(int idKamar) {
        String sql = "DELETE FROM kamar WHERE id_kamar = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idKamar);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. AMBIL DATA SATU KAMAR
    public Kamar getKamarById(int idKamar) {
        String sql = "SELECT * FROM kamar WHERE id_kamar = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idKamar);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String tipe = rs.getString("tipe_kamar");
                Kamar k;
                
                if (tipe != null && ("VIP".equalsIgnoreCase(tipe) || "Eksklusif".equalsIgnoreCase(tipe))) {
                    k = new KamarEksklusif();
                } else {
                    k = new KamarReguler();
                }
                
                k.setIdKamar(rs.getInt("id_kamar"));
                k.setIdKos(rs.getInt("id_kos"));
                k.setNomorKamar(rs.getString("nomor_kamar"));
                k.setFasilitas(rs.getString("fasilitas"));
                k.setHargaBulanan(rs.getDouble("harga_bulanan"));
                k.setStatusKamar(rs.getString("status_kamar"));
                k.setFotoKamar(rs.getString("foto_kamar")); // Ambil foto dari DB
                
                return k;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. UPDATE DATA KAMAR
    // 5. UPDATE DATA KAMAR
    public boolean updateKamar(Kamar k) {
        // Tambahkan foto_kamar=?
        String sql = "UPDATE kamar SET nomor_kamar=?, fasilitas=?, harga_bulanan=?, status_kamar=?, foto_kamar=? WHERE id_kamar=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, k.getNomorKamar());
            ps.setString(2, k.getFasilitas());
            ps.setDouble(3, k.getHargaBulanan());
            ps.setString(4, k.getStatusKamar());
            ps.setString(5, k.getFotoKamar()); // Parameter ke-5
            ps.setInt(6, k.getIdKamar());      // Parameter ke-6
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 6. UPDATE STATUS KAMAR
    public boolean updateStatusKamar(int idKamar, String status) {
        String sql = "UPDATE kamar SET status_kamar = ? WHERE id_kamar = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, idKamar);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}