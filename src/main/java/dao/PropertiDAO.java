package dao;

import db_connect.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.PropertiKos;

public class PropertiDAO {

    // Ambil daftar kos milik owner tertentu + hitung jumlah kamar otomatis
    public List<PropertiKos> getPropertiByPemilik(int idPemilik) {
        List<PropertiKos> list = new ArrayList<>();
        
        // Pakai Subquery untuk hitung total baris di tabel kamar
        String sql = "SELECT p.*, " +
                     "(SELECT COUNT(*) FROM kamar k WHERE k.id_kos = p.id_kos) AS total_kamar " +
                     "FROM properti_kos p WHERE p.id_pemilik = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idPemilik);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PropertiKos p = new PropertiKos();
                    p.setIdKos(rs.getInt("id_kos"));
                    p.setIdPemilik(rs.getInt("id_pemilik"));
                    p.setNamaKos(rs.getString("nama_kos"));
                    p.setAlamatKos(rs.getString("alamat_kos"));
                    p.setPeraturan(rs.getString("peraturan"));
                    p.setFotoKos(rs.getString("foto_kos"));
                    p.setJumlahKamar(rs.getInt("total_kamar")); // Set hasil subquery
                    
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }    
    
    // Ambil detail 1 kos berdasarkan ID Kos
    public PropertiKos getPropertiById(int idKos) {
        PropertiKos p = null;
        String sql = "SELECT p.*, (SELECT COUNT(*) FROM kamar k WHERE k.id_kos = p.id_kos) AS total_kamar " +
                     "FROM properti_kos p WHERE p.id_kos = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idKos);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new PropertiKos();
                p.setIdKos(rs.getInt("id_kos"));
                p.setIdPemilik(rs.getInt("id_pemilik"));
                p.setNamaKos(rs.getString("nama_kos"));
                p.setAlamatKos(rs.getString("alamat_kos"));
                p.setPeraturan(rs.getString("peraturan"));
                p.setFotoKos(rs.getString("foto_kos"));
                p.setJumlahKamar(rs.getInt("total_kamar"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }
    
    // Simpan data kos baru ke database
    public boolean tambahProperti(PropertiKos p) {
        String sql = "INSERT INTO properti_kos (id_pemilik, nama_kos, alamat_kos, peraturan, foto_kos) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getIdPemilik());
            ps.setString(2, p.getNamaKos());
            ps.setString(3, p.getAlamatKos());
            ps.setString(4, p.getPeraturan());
            ps.setString(5, p.getFotoKos());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update data kos yang sudah ada
    public boolean updateProperti(PropertiKos p) {
        String sql = "UPDATE properti_kos SET nama_kos=?, alamat_kos=?, peraturan=?, foto_kos=? WHERE id_kos=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNamaKos());
            ps.setString(2, p.getAlamatKos());
            ps.setString(3, p.getPeraturan());
            ps.setString(4, p.getFotoKos());
            ps.setInt(5, p.getIdKos());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hapus data kos dari tabel
    public boolean hapusProperti(int id) {
        String sql = "DELETE FROM properti_kos WHERE id_kos=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Ambil semua kos untuk pencarian (fitur filter di halaman utama)
    public List<PropertiKos> getAllProperti(String keyword) {
        List<PropertiKos> list = new ArrayList<>();
        String sql = "SELECT * FROM properti_kos";
        
        // Tambahkan filter jika user mengetik sesuatu di kolom search
        if (keyword != null && !keyword.isEmpty()) {
            sql += " WHERE nama_kos LIKE ? OR alamat_kos LIKE ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PropertiKos p = new PropertiKos();
                p.setIdKos(rs.getInt("id_kos"));
                p.setIdPemilik(rs.getInt("id_pemilik"));
                p.setNamaKos(rs.getString("nama_kos"));
                p.setAlamatKos(rs.getString("alamat_kos"));
                p.setPeraturan(rs.getString("peraturan"));
                p.setFotoKos(rs.getString("foto_kos"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}