package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.PenggunaDAO;
import model.Penyewa;
import model.PemilikKos;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Tangkap input umum dari form (Nama, Email, Password, Role)
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); 
        
        // Inisialisasi status awal (Wajib False agar aman jika proses gagal)
        PenggunaDAO dao = new PenggunaDAO();
        boolean success = false;

        // 2. Logika Pemisahan Data Berdasarkan Role
        if ("PENYEWA".equalsIgnoreCase(role)) {
            // Proses khusus Penyewa: Ambil data tambahan & panggil DAO Penyewa
            String alamat = request.getParameter("alamat");
            String noHp = request.getParameter("noHp");
            
            Penyewa penyewa = new Penyewa();
            penyewa.setNamaPanggilan(nama); 
            penyewa.setEmail(email);
            penyewa.setPassword(password);
            penyewa.setAlamatAsal(alamat);
            penyewa.setNoHp(noHp);
            
            // Status berubah jadi TRUE jika database berhasil menyimpan
            success = dao.registerPenyewa(penyewa);
            
        } else if ("PEMILIK".equalsIgnoreCase(role)) {
            // Proses khusus Pemilik: Ambil data No HP & panggil DAO Pemilik
            String noHp = request.getParameter("noHp");
            
            PemilikKos pemilik = new PemilikKos();
            pemilik.setNamaPanggilan(nama);
            pemilik.setEmail(email);
            pemilik.setPassword(password);
            pemilik.setNoHp(noHp);
            
            // Status berubah jadi TRUE jika database berhasil menyimpan
            success = dao.registerPemilik(pemilik);
        }

        // 3. Penentuan Halaman Tujuan (Redirect) berdasarkan variabel success
        if (success) {
            // Jika TRUE: Pindah ke Login dengan status sukses
            response.sendRedirect("login.jsp?status=success");
        } else {
            // Jika FALSE: Tetap di Register dengan status gagal
            response.sendRedirect("register.jsp?status=failed");
        }
    }
}