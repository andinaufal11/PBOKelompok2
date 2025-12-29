<%-- 
    Document   : checkout.jsp
    Created on : 14 Dec 2025
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.KamarDAO"%>
<%@page import="model.Kamar"%>
<%@page import="model.KamarReguler"%>
<%@page import="model.KamarEksklusif"%>
<%@page import="model.Pengguna"%>
<%@page import="model.Penyewa"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. CEK SESSION LOGIN
    Pengguna userSession = (Pengguna) session.getAttribute("user");
    
    // Validasi Login
    if (userSession == null || !"PENYEWA".equals(userSession.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. CASTING KE TIPE PENYEWA
    Penyewa penyewa = (Penyewa) userSession; 

    // ==========================================
    // VALIDASI KTP (FITUR BARU)
    // ==========================================
    // Cek apakah ktpPath kosong atau null
    if (penyewa.getKtpPath() == null || penyewa.getKtpPath().isEmpty()) {
        // Jika belum upload, arahkan ke profile dengan pesan peringatan
        response.sendRedirect("profile.jsp?status=ktp_required");
        return; // Stop eksekusi halaman ini agar tidak lanjut ke bawah
    }
    // ==========================================

    // 3. TANGKAP ID KAMAR
    String idKamarStr = request.getParameter("idKamar");
    if (idKamarStr == null || idKamarStr.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 4. AMBIL DATA KAMAR
    KamarDAO dao = new KamarDAO();
    Kamar k = dao.getKamarById(Integer.parseInt(idKamarStr));
    
    // Jika ID kamar salah atau tidak ditemukan
    if (k == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String tipeKamar = k.getTipeSpesifik(); // "Reguler" atau "Eksklusif"

    Locale localeID = new Locale("in", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Sewa | E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                
                <a href="detail-kos.jsp?id_kos=<%= k.getIdKos() %>" class="text-decoration-none text-secondary mb-3 d-block">
                    <i class="fa-solid fa-arrow-left me-2"></i>Batal & Kembali
                </a>

                <div class="card shadow border-0 rounded-4 overflow-hidden">
                    <div class="card-header bg-success text-white py-3">
                        <h4 class="mb-0 fw-bold"><i class="fa-solid fa-file-invoice me-2"></i>Konfirmasi Pesanan</h4>
                    </div>
                    
                    <div class="card-body p-4">
                        
                        <div class="d-flex align-items-center mb-4 p-3 bg-light rounded border">
                            <div class="me-3">
                                <div class="bg-white p-3 rounded shadow-sm border text-center" style="width: 80px; height: 80px;">
                                    <i class="fa-solid fa-bed fa-2x text-success"></i>
                                </div>
                            </div>
                            <div class="flex-grow-1">
                                <h5 class="fw-bold mb-1">Kamar No. <%= k.getNomorKamar() %> <span class="badge bg-secondary"><%= tipeKamar %></span></h5>
                                <p class="text-muted small mb-0"><%= k.getFasilitas() %></p>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">Harga/bulan</small>
                                <h5 class="fw-bold text-success" id="displayHargaSatuan" data-harga="<%= k.getHargaBulanan() %>">
                                    <%= formatRupiah.format(k.getHargaBulanan()) %>
                                </h5>
                            </div>
                        </div>

                        <% if (k instanceof KamarReguler) { %>
                            <div class="alert alert-success d-flex align-items-center small" role="alert">
                                <i class="fa-solid fa-tag me-2"></i>
                                <div><strong>Promo Reguler:</strong> Dapatkan diskon 5% jika menyewa minimal 3 bulan!</div>
                            </div>
                        <% } else if (k instanceof KamarEksklusif) { %>
                            <div class="alert alert-info d-flex align-items-center small" role="alert">
                                <i class="fa-solid fa-circle-info me-2"></i>
                                <div><strong>Info Eksklusif:</strong> Harga total akan dikenakan biaya layanan sebesar 10%.</div>
                            </div>
                        <% } %>

                        <form action="prosesBooking" method="POST">
                            
                            <input type="hidden" name="idKamar" value="<%= k.getIdKamar() %>">
                            
                            <input type="hidden" id="tipeKamar" value="<%= tipeKamar %>">
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Nama Penyewa</label>
                                    <input type="text" class="form-control bg-light" 
                                           value="<%= (penyewa.getNamaLengkap() != null) ? penyewa.getNamaLengkap() : userSession.getNamaPanggilan() %>" readonly>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Nomor HP</label>
                                    <input type="text" class="form-control bg-light" 
                                           value="<%= (penyewa.getNoHp() != null) ? penyewa.getNoHp() : "-" %>" readonly>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Mulai Ngekos</label>
                                    <input type="date" name="tanggalMulai" class="form-control" required>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Durasi Sewa</label>
                                    <select name="durasi" id="durasiSelect" class="form-select" onchange="hitungTotal()" required>
                                        <option value="1">1 Bulan</option>
                                        <option value="3">3 Bulan</option>
                                        <option value="6">6 Bulan</option>
                                        <option value="12">1 Tahun</option>
                                    </select>
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h5 class="text-secondary mb-0">Total Pembayaran</h5>
                                    <small class="text-muted" id="infoDetailHarga">*Pembayaran dilakukan saat check-in</small>
                                </div>
                                <h2 class="fw-bold text-success" id="totalBayarDisplay">
                                    <%= formatRupiah.format(k.getHargaBulanan()) %>
                                </h2>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-success btn-lg fw-bold shadow-sm">
                                    Booking Sekarang <i class="fa-solid fa-check-circle ms-2"></i>
                                </button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function hitungTotal() {
            let hargaPerBulan = parseFloat(document.getElementById("displayHargaSatuan").getAttribute("data-harga"));
            let durasi = parseInt(document.getElementById("durasiSelect").value);
            let tipe = document.getElementById("tipeKamar").value;
            
            let total = hargaPerBulan * durasi;
            let pesanDetail = "*Pembayaran dilakukan saat check-in";

            if (tipe === "Reguler") {
                if (durasi >= 3) {
                    let diskon = total * 0.05;
                    total = total - diskon;
                    pesanDetail = "Termasuk Diskon 5% (Promo Reguler)";
                    document.getElementById("totalBayarDisplay").classList.remove("text-danger");
                    document.getElementById("totalBayarDisplay").classList.add("text-success");
                }
            } else if (tipe === "Eksklusif") {
                let layanan = total * 0.10;
                total = total + layanan;
                pesanDetail = "Termasuk Biaya Layanan 10% (Eksklusif)";
            }

            let formattedTotal = new Intl.NumberFormat('id-ID', { 
                style: 'currency', 
                currency: 'IDR', 
                minimumFractionDigits: 0
            }).format(total);
            
            document.getElementById("totalBayarDisplay").innerText = formattedTotal;
            document.getElementById("infoDetailHarga").innerText = pesanDetail;
        }
        
        window.onload = hitungTotal;
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>