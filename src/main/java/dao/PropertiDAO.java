/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_connect.DBConnection;
import model.PropertiKos;

public class PropertiDAO {

    // FITUR 2: TAMBAH PROPERTI KOS BARU
    public boolean tambahProperti(PropertiKos properti) {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO properti_kos (id_pemilik, nama_kos, alamat_kos, peraturan) VALUES (?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, properti.getIdPemilik());
            ps.setString(2, properti.getNamaKos());
            ps.setString(3, properti.getAlamatKos());
            ps.setString(4, properti.getPeraturan());
            
            int row = ps.executeUpdate();
            return row > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // FITUR 2: LIHAT DAFTAR KOS MILIK SENDIRI (AGREGASI)
    public List<PropertiKos> getPropertiByPemilik(int idPemilik) {
        List<PropertiKos> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM properti_kos WHERE id_pemilik = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idPemilik);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                PropertiKos p = new PropertiKos();
                p.setIdKos(rs.getInt("id_kos"));
                p.setIdPemilik(rs.getInt("id_pemilik"));
                p.setNamaKos(rs.getString("nama_kos"));
                p.setAlamatKos(rs.getString("alamat_kos"));
                p.setPeraturan(rs.getString("peraturan"));
                
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
