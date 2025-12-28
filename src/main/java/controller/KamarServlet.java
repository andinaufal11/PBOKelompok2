/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // PENTING
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // PENTING
import dao.KamarDAO;
import model.Kamar;
import model.KamarReguler;
import model.KamarEksklusif;

/**
 *
 * @author Fachrul Rozi
 */
@WebServlet("/kamar")
@MultipartConfig // PENTING: Agar bisa baca file upload dari Modal
public class KamarServlet extends HttpServlet {

    // 1. MENANGANI REQUEST GET (Hapus & Link)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // --- LOGIKA HAPUS KAMAR ---
        if ("delete".equals(action)) {
            try {
                int idKamar = Integer.parseInt(request.getParameter("id"));
                int idKos = Integer.parseInt(request.getParameter("idKos"));

                KamarDAO dao = new KamarDAO();
                boolean sukses = dao.hapusKamar(idKamar);

                if (sukses) {
                    response.sendRedirect("kelola-kamar.jsp?id_kos=" + idKos + "&status=deleted");
                } else {
                    response.sendRedirect("kelola-kamar.jsp?id_kos=" + idKos + "&status=error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard-pemilik.jsp");
            }
        }
    }

    // 2. MENANGANI REQUEST POST (Tambah & Edit)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        KamarDAO dao = new KamarDAO();

        // --- LOGIKA TAMBAH KAMAR BARU ---
        if ("add".equals(action)) {
            try {
                // A. Ambil Data Dasar
                int idKos = Integer.parseInt(request.getParameter("idKos"));
                String noKamar = request.getParameter("noKamar");
                String tipeInput = request.getParameter("tipe");
                String fasilitasUmum = request.getParameter("fasilitas");
                double harga = Double.parseDouble(request.getParameter("harga"));

                // --- LOGIKA UPLOAD FOTO KAMAR ---
                String fileName = "default_kamar.jpg";
                Part filePart = request.getPart("fotoKamar");
                
                if (filePart != null && filePart.getSize() > 0) {
                    String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = originalName.substring(originalName.lastIndexOf("."));
                    fileName = UUID.randomUUID().toString() + ext;
                    
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    filePart.write(uploadPath + File.separator + fileName);
                }
                // --------------------------------

                Kamar k;
                String detailTambahan = "";

                // B. Cek Tipe Kamar
                if ("VIP".equalsIgnoreCase(tipeInput)) {
                    // ---> TIPE EKSKLUSIF
                    KamarEksklusif kEk = new KamarEksklusif();
                    String luas = request.getParameter("luasArea");
                    String fasPlus = request.getParameter("fasilitasTambahan");

                    kEk.setLuasArea(luas);
                    kEk.setFasilitasTambahan(fasPlus);
                    detailTambahan = " [Luas: " + luas + " | Extra: " + fasPlus + "]";
                    k = kEk;

                } else {
                    // ---> TIPE REGULER
                    KamarReguler kReg = new KamarReguler();
                    String ukuran = request.getParameter("ukuran");
                    String kasur = request.getParameter("jenisKasur");

                    kReg.setUkuran(ukuran);
                    kReg.setJenisKasur(kasur);
                    detailTambahan = " [Ukuran: " + ukuran + " | Kasur: " + kasur + "]";
                    k = kReg;
                }

                // C. Set Data ke Objek Utama
                k.setIdKos(idKos);
                k.setNomorKamar(noKamar);
                k.setHargaBulanan(harga);
                k.setFasilitas(fasilitasUmum + detailTambahan);
                
                // Set Foto Kamar
                k.setFotoKamar(fileName);

                // D. Simpan via DAO
                boolean sukses = dao.tambahKamar(k);

                if (sukses) {
                    response.sendRedirect("kelola-kamar.jsp?id_kos=" + idKos + "&status=added");
                } else {
                    response.sendRedirect("kelola-kamar.jsp?id_kos=" + idKos + "&status=failed");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard-pemilik.jsp?status=error");
            }

        // --- LOGIKA UPDATE / EDIT KAMAR (DIPERBAIKI) ---
        } else if ("update".equals(action)) { 
            try {
                // A. Ambil Data Form
                int idKamar = Integer.parseInt(request.getParameter("idKamar")); 
                int idKos = Integer.parseInt(request.getParameter("idKos")); 
                String noKamar = request.getParameter("noKamar"); 
                String fasilitas = request.getParameter("fasilitas");
                double harga = Double.parseDouble(request.getParameter("harga")); 
                String status = request.getParameter("status");
                
                // B. Ambil Foto Lama
                String fotoLama = request.getParameter("fotoLama");

                // C. Cek Upload Foto Baru
                String fileName = fotoLama; // Default pakai foto lama
                
                Part filePart = request.getPart("fotoKamar");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = originalName.substring(originalName.lastIndexOf("."));
                    fileName = UUID.randomUUID().toString() + ext;
                    
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    
                    filePart.write(uploadPath + File.separator + fileName);
                }

                // D. Set Data ke Model
                Kamar k = new Kamar(); 
                k.setIdKamar(idKamar); 
                k.setNomorKamar(noKamar); 
                k.setFasilitas(fasilitas); 
                k.setHargaBulanan(harga); 
                k.setStatusKamar(status); 
                k.setFotoKamar(fileName); // Foto Baru atau Lama

                // E. Update ke Database
                boolean sukses = dao.updateKamar(k); 

                if (sukses) {
                    response.sendRedirect("kelola-kamar.jsp?id_kos=" + idKos + "&status=updated");
                } else {
                    response.sendRedirect("kelola-kamar.jsp?id_kos=" + idKos + "&status=update_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard-pemilik.jsp?status=error");
            }
        }
    }
}