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

import dao.PropertiDAO;
import model.PropertiKos;
import model.Pengguna;

@WebServlet("/properti") // URL Pattern untuk akses servlet ini
public class PropertiServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Session (Pastikan yang request adalah Pemilik Kos yang login)
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");
        
        if (user == null || !"PEMILIK".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Ambil Data dari Form
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String namaKos = request.getParameter("namaKos");
            String alamatKos = request.getParameter("alamatKos");
            String peraturan = request.getParameter("peraturan");
            
            // 3. Masukkan ke Objek Model
            PropertiKos properti = new PropertiKos();
            properti.setIdPemilik(user.getIdPengguna()); // Ambil ID dari Session User
            properti.setNamaKos(namaKos);
            properti.setAlamatKos(alamatKos);
            properti.setPeraturan(peraturan);
            
            // 4. Simpan ke Database via DAO
            PropertiDAO dao = new PropertiDAO();
            boolean sukses = dao.tambahProperti(properti);
            
            // 5. Redirect kembali ke Dashboard
            if (sukses) {
                response.sendRedirect("dashboard-pemilik.jsp?status=added");
            } else {
                response.sendRedirect("tambah-kos.jsp?status=failed");
            }
        }
    }
}
