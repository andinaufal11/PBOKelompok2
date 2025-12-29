package controller;

import dao.KamarDAO;
import dao.TransaksiDAO;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Kamar;
import model.KamarReguler;
import model.KamarEksklusif;
import model.Pengguna;
import model.TransaksiSewa;

@WebServlet("/prosesBooking") 
public class BookingServlet extends HttpServlet {

    // =======================================================================
    // 1. doPost: MEMBUAT BOOKING BARU (Status: Menunggu Konfirmasi)
    // =======================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");
        
        if (user == null) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }

        try {
            String idKamarStr = request.getParameter("idKamar");
            String tglMulaiStr = request.getParameter("tanggalMulai");
            String durasiStr = request.getParameter("durasi");

            if (idKamarStr == null || tglMulaiStr == null || durasiStr == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            int idKamar = Integer.parseInt(idKamarStr);
            int durasi = Integer.parseInt(durasiStr);
            
            KamarDAO kamarDao = new KamarDAO();
            Kamar kamar = kamarDao.getKamarById(idKamar); 
            
            // CEK: Apakah kamar sudah terisi?
            if ("Terisi".equalsIgnoreCase(kamar.getStatusKamar())) {
                response.sendRedirect("detail-kos.jsp?id_kos=" + kamar.getIdKos() + "&error=room_taken");
                return;
            }

            // HITUNG HARGA
            double hargaDasar = kamar.getHargaBulanan() * durasi;
            double totalAkhir = hargaDasar;

            if (kamar instanceof KamarReguler) {
                totalAkhir = hargaDasar - ((KamarReguler) kamar).hitungDiskon(durasi);
            } else if (kamar instanceof KamarEksklusif) {
                totalAkhir = hargaDasar + ((KamarEksklusif) kamar).hitungBiayaLayanan(durasi);
            }
            
            // SIMPAN TRANSAKSI
            LocalDate tglMulai = LocalDate.parse(tglMulaiStr); 
            TransaksiSewa trans = new TransaksiSewa();
            trans.setPenyewa(user);
            trans.setKamar(kamar);
            trans.setTanggalMulai(tglMulai.toString());
            trans.setDurasiSewa(durasi);
            trans.setTotalBayar(totalAkhir); 
            
            // Status Awal: Menunggu Konfirmasi
            trans.setStatusPembayaran("Menunggu Konfirmasi"); 
            
            TransaksiDAO transDao = new TransaksiDAO();
            boolean sukses = transDao.buatBooking(trans);

            if (sukses) {
                // KUNCI KAMAR JADI TERISI
                kamarDao.updateStatusKamar(idKamar, "Terisi");
                response.sendRedirect("riwayat-sewa.jsp?status=success");
            } else {
                response.sendRedirect("checkout.jsp?idKamar=" + idKamar + "&error=db_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=system_error");
        }
    }

    // =======================================================================
    // 2. doGet: ACC (TERIMA) / TOLAK / BATAL
    // =======================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");       
        String idTransStr = request.getParameter("id");       
        String idKamarStr = request.getParameter("idKamar");
        String source = request.getParameter("source"); // "owner", "konfirmasi", "penghuni"

        if (idTransStr != null && idKamarStr != null) {
            try {
                int idTransaksi = Integer.parseInt(idTransStr);
                int idKamar = Integer.parseInt(idKamarStr);
                
                TransaksiDAO transDao = new TransaksiDAO();
                KamarDAO kamarDao = new KamarDAO();
                boolean sukses = false;

                // --- LOGIKA TERIMA (ACC) ---
                if ("terima".equals(action)) {
                    sukses = transDao.updateStatus(idTransaksi, "Disetujui");
                    // Kamar tetap 'Terisi'
                
                // --- LOGIKA TOLAK ---
                } else if ("tolak".equals(action)) {
                    sukses = transDao.updateStatus(idTransaksi, "Ditolak");
                    if (sukses) {
                        kamarDao.updateStatusKamar(idKamar, "Tersedia"); // Buka kunci kamar
                    }

                // --- LOGIKA BATAL (Oleh Penyewa/Pemilik) ---
                } else if ("batal".equals(action)) {
                    sukses = transDao.updateStatus(idTransaksi, "Dibatalkan");
                    if (sukses) {
                        kamarDao.updateStatusKamar(idKamar, "Tersedia"); // Buka kunci kamar
                    }
                }

                // --- REDIRECT LOGIC YANG DIPERBAIKI ---
                if ("konfirmasi".equals(source)) {
                    // Balik ke Inbox Konfirmasi
                    response.sendRedirect("konfirmasi.jsp?status=" + (sukses ? "processed" : "error"));
                    
                } else if ("owner".equals(source)) {
                    // Balik ke Laporan Arsip
                    response.sendRedirect("laporan-pemilik.jsp?status=" + (sukses ? "cancelled" : "error"));
                    
                } else if ("penghuni".equals(source)) { 
                    // [FIX] Balik ke Data Penghuni (INI YANG SEBELUMNYA HILANG)
                    response.sendRedirect("data-penghuni.jsp?status=" + (sukses ? "cancelled" : "error"));
                    
                } else {
                    // Default: Balik ke Riwayat Sewa (Penyewa)
                    response.sendRedirect("riwayat-sewa.jsp?status=" + (sukses ? "cancelled" : "error"));
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("index.jsp");
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}