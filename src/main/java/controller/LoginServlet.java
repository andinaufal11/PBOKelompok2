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

// Menentukan alamat akses Servlet (Endpoint)
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Menangani pengiriman form login
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil data dari input form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Verifikasi data ke Database melalui DAO
        PenggunaDAO dao = new PenggunaDAO();
        Pengguna user = dao.login(email, password);

        // Jika data ditemukan (Login Berhasil)
        if (user != null) {
            
            // 3. Simpan status login di Session agar user tidak perlu login ulang di tiap halaman
            HttpSession session = request.getSession();
            session.setAttribute("user", user); 
            session.setAttribute("role", user.getRole());

            // 4. Arahkan user ke Dashboard sesuai hak akses (Role)
            if ("PEMILIK".equals(user.getRole())) {
                response.sendRedirect("dashboard-pemilik.jsp");
            } else {
                response.sendRedirect("index.jsp"); 
            }
            return; // Berhenti agar tidak terjadi error "Response already committed"
            
        } else {
            // Jika data tidak cocok, balikkan ke login dengan tanda error
            response.sendRedirect("login.jsp?status=failed");
            return;
        }
    }
    
    // Menangani klik link logout atau akses URL langsung
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Cek apakah user berniat Logout
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false); 
            if (session != null) {
                // Hapus semua data login dari server
                session.invalidate(); 
            }
            
            // Arahkan kembali ke halaman login
            response.sendRedirect("login.jsp?status=logout");
            return; 
        }
        
        // Default: lempar ke form login
        response.sendRedirect("login.jsp");
    }
}