/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
//package controller;
//
//import dao.PenggunaDAO;
//import model.PemilikKos;
//import model.Pengguna;
//import java.io.File;
//import java.io.IOException;
//import java.nio.file.Files;
//import java.nio.file.StandardCopyOption;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//import javax.servlet.http.Part;
//
//@WebServlet("/updateProfile")
//@MultipartConfig(
//    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
//    maxFileSize = 1024 * 1024 * 5,       // 5 MB
//    maxRequestSize = 1024 * 1024 * 10    // 10 MB
//)
//public class ProfileServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        Pengguna user = (Pengguna) session.getAttribute("user");
//
//        // Cek login & role
//        if (user == null || !"PEMILIK".equals(user.getRole())) {
//            response.sendRedirect("login.jsp");
//            return;
//        }
//
//        // Ambil File dari Form
//        Part filePart = request.getPart("fileSK");
//        
//        if (filePart != null && filePart.getSize() > 0) {
//            // 1. Tentukan lokasi simpan (Folder 'uploads' di dalam project web)
//            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
//            File uploadDir = new File(uploadPath);
//            if (!uploadDir.exists()) uploadDir.mkdir();
//
//            // 2. Buat nama file unik
//            String fileName = "SK_" + user.getIdPengguna() + "_" + System.currentTimeMillis() + ".jpg";
//            String fullPath = uploadPath + File.separator + fileName;
//
//            // 3. Simpan file ke server
//            filePart.write(fullPath);
//
//            // 4. Update Database via DAO
//            PenggunaDAO dao = new PenggunaDAO();
//            boolean success = dao.updateSKPemilik(user.getIdPengguna(), fileName);
//
//            if (success) {
//                // 5. Update data di Session agar tampilan langsung berubah tanpa relogin
//                PemilikKos pemilikUpdate = (PemilikKos) user;
//                pemilikUpdate.setSkPath(fileName);
//                session.setAttribute("user", pemilikUpdate);
//                
//                response.sendRedirect("profile.jsp?status=success");
//            } else {
//                response.sendRedirect("profile.jsp?status=db_error");
//            }
//        } else {
//            response.sendRedirect("profile.jsp?status=no_file");
//        }
//    }
//}

package controller;

import dao.PenggunaDAO;
import model.PemilikKos;
import model.Penyewa; // Tambahan
import model.Pengguna;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/updateProfile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class ProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");

        // Cek login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = user.getRole();
        
        // Tentukan nama input file berdasarkan Role
        // Jika Pemilik: input name="fileSK", Jika Penyewa: input name="fileKTP"
        String inputName = "PEMILIK".equals(role) ? "fileSK" : "fileKTP";

        // Ambil File dari Form
        Part filePart = request.getPart(inputName);
        
        if (filePart != null && filePart.getSize() > 0) {
            // 1. Tentukan lokasi simpan
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            // 2. Buat nama file unik (Prefix beda agar rapi)
            String prefix = "PEMILIK".equals(role) ? "SK_" : "KTP_";
            String fileName = prefix + user.getIdPengguna() + "_" + System.currentTimeMillis() + ".jpg";
            String fullPath = uploadPath + File.separator + fileName;

            // 3. Simpan file ke server
            filePart.write(fullPath);

            // 4. Update Database via DAO & Update Session
            PenggunaDAO dao = new PenggunaDAO();
            boolean success = false;
            
            if ("PEMILIK".equals(role)) {
                // --- LOGIKA PEMILIK (SK) ---
                success = dao.updateSKPemilik(user.getIdPengguna(), fileName);
                if (success) {
                    PemilikKos pemilikUpdate = (PemilikKos) user;
                    pemilikUpdate.setSkPath(fileName);
                    session.setAttribute("user", pemilikUpdate);
                }
                
            } else if ("PENYEWA".equals(role)) {
                // --- LOGIKA PENYEWA (KTP) ---
                success = dao.updateKTPPenyewa(user.getIdPengguna(), fileName);
                if (success) {
                    Penyewa penyewaUpdate = (Penyewa) user;
                    penyewaUpdate.setKtpPath(fileName);
                    session.setAttribute("user", penyewaUpdate);
                }
            }

            if (success) {
                response.sendRedirect("profile.jsp?status=success");
            } else {
                response.sendRedirect("profile.jsp?status=db_error");
            }
        } else {
            response.sendRedirect("profile.jsp?status=no_file");
        }
    }
}