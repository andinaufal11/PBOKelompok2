/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; 
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part; 
import dao.PropertiDAO;
import model.PropertiKos;
import model.Pengguna;
import model.PemilikKos; // PENTING: Ditambahkan agar bisa cek atribut SK

@WebServlet("/properti")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class PropertiServlet extends HttpServlet {

    // ==========================================
    // METHOD DOGET: UNTUK MENANGANI LINK (EDIT & HAPUS)
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        PropertiDAO dao = new PropertiDAO();

        // 1. Cek Login (Keamanan)
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");
        if (user == null || !"PEMILIK".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Logika HAPUS
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if(idStr != null) {
                int id = Integer.parseInt(idStr);
                boolean sukses = dao.hapusProperti(id);
                
                if (sukses) {
                    response.sendRedirect("dashboard-pemilik.jsp?status=deleted");
                } else {
                    response.sendRedirect("dashboard-pemilik.jsp?status=error_delete");
                }
            } else {
                response.sendRedirect("dashboard-pemilik.jsp");
            }

        // 3. Logika EDIT (Ambil data lalu lempar ke form edit)
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if(idStr != null) {
                int id = Integer.parseInt(idStr);
                PropertiKos prop = dao.getPropertiById(id);
                
                // Simpan objek properti ke request agar bisa dibaca di JSP
                request.setAttribute("properti", prop);
                
                // Forward ke halaman edit-kos.jsp
                RequestDispatcher rd = request.getRequestDispatcher("edit-kos.jsp");
                rd.forward(request, response);
            }
        } else {
            // Jika akses langsung /properti tanpa action, kembalikan ke dashboard
            response.sendRedirect("dashboard-pemilik.jsp");
        }
    }

    // ==========================================
    // METHOD DOPOST: UNTUK MENANGANI FORM (TAMBAH & UPDATE)
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String action = request.getParameter("action");
        PropertiDAO dao = new PropertiDAO();

        // 1. Logika TAMBAH DATA BARU
        if ("add".equals(action)) {
            try {
                // ============================================================
                // LOGIC GATE (GERBANG): CEK SK SEBELUM LANJUT
                // ============================================================
                if (user instanceof PemilikKos) {
                    PemilikKos pemilik = (PemilikKos) user;
                    
                    // Cek apakah SK Path kosong/null
                    if (pemilik.getSkPath() == null || pemilik.getSkPath().trim().isEmpty()) {
                        System.out.println("BLOKIR: User " + pemilik.getNamaPanggilan() + " belum upload SK.");
                        // Redirect ke profile dengan peringatan
                        response.sendRedirect("profile.jsp?alert=wajib_sk");
                        return; // STOP DI SINI! Jangan proses kode di bawahnya.
                    }
                }
                // ============================================================

                String nama = request.getParameter("namaKos");
                String alamat = request.getParameter("alamatKos");
                String aturan = request.getParameter("peraturan");
                
                // --- LOGIKA UPLOAD FOTO ---
                String fileName = "default_kos.jpg"; // Default jika tidak ada foto
                Part filePart = request.getPart("fotoKos"); // Ambil file dari form
                
                if (filePart != null && filePart.getSize() > 0) {
                    // Buat nama file unik (UUID) agar tidak bentrok
                    String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = originalName.substring(originalName.lastIndexOf("."));
                    fileName = UUID.randomUUID().toString() + ext;
                    
                    // Tentukan lokasi simpan (Folder 'images' di dalam Web Pages)
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir(); // Buat folder jika belum ada
                    
                    // Simpan file
                    filePart.write(uploadPath + File.separator + fileName);
                    System.out.println("Foto Kos disimpan di: " + uploadPath);
                }
                // ---------------------------

                PropertiKos p = new PropertiKos();
                p.setIdPemilik(user.getIdPengguna());
                p.setNamaKos(nama);
                p.setAlamatKos(alamat);
                p.setPeraturan(aturan);
                p.setFotoKos(fileName); // Set nama file ke model
                
                boolean sukses = dao.tambahProperti(p);
                
                if (sukses) {
                    response.sendRedirect("dashboard-pemilik.jsp?status=added");
                } else {
                    response.sendRedirect("dashboard-pemilik.jsp?status=error_db");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("tambah-kos.jsp?status=error");
            }

        // 2. Logika UPDATE DATA LAMA
        } else if ("update".equals(action)) {
            try {
                // A. Ambil Data Teks
                int idKos = Integer.parseInt(request.getParameter("idKos"));
                String nama = request.getParameter("namaKos");
                String alamat = request.getParameter("alamatKos");
                String aturan = request.getParameter("peraturan");
                
                // B. Ambil Nama Foto Lama (Dikirim dari hidden input di JSP)
                String fotoLama = request.getParameter("fotoLama");

                // C. Logika Upload Foto (Cek apakah user ganti foto?)
                String fileName = fotoLama; // Default: Gunakan foto lama
                
                Part filePart = request.getPart("fotoKos"); // Cek input file
                
                // Jika user upload file baru (ukurannya > 0)
                if (filePart != null && filePart.getSize() > 0) {
                    String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = originalName.substring(originalName.lastIndexOf("."));
                    fileName = UUID.randomUUID().toString() + ext; // Generate nama baru
                    
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    filePart.write(uploadPath + File.separator + fileName); // Simpan file baru
                }

                // D. Set Data ke Model
                PropertiKos p = new PropertiKos();
                p.setIdKos(idKos);
                p.setNamaKos(nama);
                p.setAlamatKos(alamat);
                p.setPeraturan(aturan);
                p.setFotoKos(fileName); // Masukkan nama file (baru atau lama)

                // E. Update Database
                boolean sukses = dao.updateProperti(p);
                
                if (sukses) {
                    response.sendRedirect("dashboard-pemilik.jsp?status=updated");
                } else {
                    response.sendRedirect("dashboard-pemilik.jsp?status=error_update");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard-pemilik.jsp?status=error");
            }
        }
    }
}