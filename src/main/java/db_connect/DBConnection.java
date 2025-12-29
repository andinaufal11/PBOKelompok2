/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package db_connect;

/**
 *
 * @author andin
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Konfigurasi Database
    private static final String URL = "jdbc:mysql://localhost:3306/e_kos";
    private static final String USER = "root";     // Default user XAMPP/MySQL
    private static final String PASSWORD = "";     // Default password XAMPP (biasanya kosong)
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // 1. Register Driver MySQL
            Class.forName(DRIVER);
            
            // 2. Buat Koneksi
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            // System.out.println("Koneksi Berhasil!"); // Uncomment untuk debugging
            
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL tidak ditemukan! Pastikan library mysql-connector sudah ditambahkan.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Gagal terhubung ke Database e_kos!");
            e.printStackTrace();
        }
        
        return connection;
    }
}
