/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil data dari Form
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); 
        
        PenggunaDAO dao = new PenggunaDAO();
        boolean success = false;

        System.out.println("Mencoba Register: " + email + " sebagai " + role); // Debugging

        if ("PENYEWA".equalsIgnoreCase(role)) {
            String alamat = request.getParameter("alamat");
            String noHp = request.getParameter("noHp");
            
            Penyewa penyewa = new Penyewa();
            // PERBAIKAN DI SINI: Set kedua nama (Panggilan & Lengkap)
            penyewa.setNamaPanggilan(nama); 
            penyewa.setNamaLengkap(nama); // <--- INI YANG TADI KURANG!
            
            penyewa.setEmail(email);
            penyewa.setPassword(password);
            penyewa.setAlamatAsal(alamat);
            penyewa.setNoHp(noHp);
            
            success = dao.registerPenyewa(penyewa);
            
        } else if ("PEMILIK".equalsIgnoreCase(role)) {
            String noHp = request.getParameter("noHp");
            
            PemilikKos pemilik = new PemilikKos();
            pemilik.setNamaPanggilan(nama);
            pemilik.setEmail(email);
            pemilik.setPassword(password);
            pemilik.setNoHp(noHp);
            
            success = dao.registerPemilik(pemilik);
        }

        if (success) {
            System.out.println("Register SUKSES redirect ke login");
            response.sendRedirect("login.jsp?status=success");
        } else {
            System.out.println("Register GAGAL redirect ke register");
            response.sendRedirect("register.jsp?status=failed");
        }
    }
}
