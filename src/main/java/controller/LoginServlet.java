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
import javax.servlet.http.HttpSession;

import dao.PenggunaDAO;
import model.Pengguna;

// URL yang akan dipanggil form login
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil input dari form login.jsp
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        PenggunaDAO dao = new PenggunaDAO();
        
        // 2. Cek ke Database via DAO
        // Polimorfisme: method ini mengembalikan objek Pengguna (bisa Penyewa/Pemilik)
        Pengguna user = dao.login(email, password);

        if (user != null) {
            // LOGIN SUKSES
            
            // 3. Buat Session (Menyimpan data user selama browser dibuka)
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // Simpan objek user utuh
            session.setAttribute("role", user.getRole()); // Simpan role untuk filter menu nanti

            // 4. Arahkan ke Dashboard sesuai Role
            if ("PEMILIK".equals(user.getRole())) {
                response.sendRedirect("dashboard-pemilik.jsp");
            } else {
                response.sendRedirect("index.jsp"); // Halaman utama pencari kos
            }
            
        } else {
            // LOGIN GAGAL
            // Arahkan kembali ke login.jsp dengan pesan error
            response.sendRedirect("login.jsp?status=failed");
        }
    }
    
    // Opsional: Handle Logout (GET Request)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); // Hapus sesi
            }
            response.sendRedirect("login.jsp?status=logout");
        }
    }
}
