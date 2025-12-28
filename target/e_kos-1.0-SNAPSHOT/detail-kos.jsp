<%-- 
    Document   : detail-kos.jsp
    Created on : 14 Dec 2025
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="model.PropertiKos"%>
<%@page import="model.Kamar"%>
<%@page import="model.Penyewa"%> 
<%@page import="dao.PropertiDAO"%>
<%@page import="dao.KamarDAO"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // LOGIC JAVA TETAP SAMA
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PENYEWA".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    boolean isKtpUploaded = false;
    if (user instanceof Penyewa) {
        Penyewa p = (Penyewa) user;
        if (p.getKtpPath() != null && !p.getKtpPath().isEmpty()) {
            isKtpUploaded = true;
        }
    }

    String idKosStr = request.getParameter("id_kos");
    if (idKosStr == null || idKosStr.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }
    int idKos = Integer.parseInt(idKosStr);

    PropertiDAO proDao = new PropertiDAO();
    KamarDAO kamDao = new KamarDAO();

    PropertiKos kos = proDao.getPropertiById(idKos); 
    List<Kamar> listKamar = kamDao.getKamarByKos(idKos);
    Locale localeID = new Locale("in", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Kos - <%= (kos != null) ? kos.getNamaKos() : "Info" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #0d2c56; /* Navy */
            --accent-color: #fca311;  /* Gold */
        }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }

        .card-kamar { transition: transform 0.2s; border: none; }
        .card-kamar:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        
        .hero-section { background: white; border-bottom: 1px solid #dee2e6; }
        .text-navy { color: var(--primary-color); }
        .btn-gold { background-color: var(--accent-color); color: #000; border: none; font-weight: bold; }
        .btn-gold:hover { background-color: #e0910f; }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fa-solid fa-arrow-left me-2"></i>Kembali
            </a>
            <span class="text-white">Detail Properti</span>
        </div>
    </nav>

    <% if (kos != null) { %>

    <div class="hero-section shadow-sm mb-5">
        <div class="container py-5">
            <div class="row align-items-center">
                <div class="col-md-6 mb-4 mb-md-0">
                    <img src="images/<%= kos.getFotoKos() %>" 
                         class="img-fluid rounded-3 shadow" 
                         alt="Foto Kos" 
                         style="width: 100%; height: 400px; object-fit: cover;"
                         onerror="this.src='https://placehold.co/800x500?text=No+Image';">
                </div>
                
                <div class="col-md-6">
                    <h1 class="display-5 fw-bold text-navy mb-2"><%= kos.getNamaKos() %></h1>
                    <p class="fs-5 text-muted mb-4">
                        <i class="fa-solid fa-map-location-dot text-danger me-2"></i><%= kos.getAlamatKos() %>
                    </p>
                    
                    <div class="card bg-light border-0 p-3 mb-3">
                        <div class="d-flex">
                            <i class="fa-solid fa-circle-info text-info fs-4 me-3 mt-1"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Peraturan & Ketentuan</h6>
                                <p class="mb-0 small text-secondary"><%= kos.getPeraturan() %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        
        <% if (!isKtpUploaded) { %>
            <div class="alert alert-warning mb-5 d-flex align-items-center shadow-sm rounded-3">
                <i class="fa-solid fa-triangle-exclamation fs-3 me-3"></i>
                <div>
                    <strong>Akun Belum Lengkap!</strong>
                    <div class="small">Anda harus mengunggah foto KTP sebelum dapat memesan kamar.</div>
                </div>
                <a href="profile.jsp" class="btn btn-sm btn-outline-dark ms-auto fw-bold">Upload KTP</a>
            </div>
        <% } %>

        <div class="d-flex align-items-center mb-4">
            <h3 class="fw-bold text-navy mb-0">Pilihan Kamar</h3>
            <div class="ms-3 border-bottom flex-grow-1"></div>
        </div>

        <div class="row g-4">
            <% 
                if (listKamar != null && !listKamar.isEmpty()) {
                    for (Kamar k : listKamar) {
                        boolean isAvailable = "Tersedia".equalsIgnoreCase(k.getStatusKamar());
            %>
            <div class="col-md-4">
                <div class="card card-kamar h-100 shadow-sm rounded-3 overflow-hidden bg-white">
                    
                    <div style="height: 220px; overflow: hidden; position: relative;">
                        <img src="images/<%= k.getFotoKamar() %>" class="w-100 h-100" style="object-fit: cover;"
                             alt="Foto Kamar" onerror="this.src='https://placehold.co/400x300?text=No+Image';">
                        
                        <div class="position-absolute top-0 end-0 m-2">
                             <% if("VIP".equalsIgnoreCase(k.getTipeSpesifik()) || "Eksklusif".equalsIgnoreCase(k.getTipeSpesifik())) { %>
                                <span class="badge bg-warning text-dark shadow-sm"><i class="fa-solid fa-crown me-1"></i>Eksklusif</span>
                            <% } else { %>
                                <span class="badge bg-light text-dark shadow-sm">Reguler</span>
                            <% } %>
                        </div>
                        <div class="position-absolute top-0 start-0 m-2">
                            <span class="badge bg-dark bg-opacity-75">No. <%= k.getNomorKamar() %></span>
                        </div>
                    </div>

                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h4 class="card-title text-navy fw-bold mb-0">
                                    <%= formatRupiah.format(k.getHargaBulanan()) %>
                                </h4>
                                <small class="text-muted">/ bulan</small>
                            </div>
                        </div>

                        <div class="mb-4">
                            <small class="text-uppercase fw-bold text-muted" style="font-size: 0.75rem;">Fasilitas:</small>
                            <p class="card-text text-secondary small mt-1">
                                <%= k.getFasilitas() %>
                            </p>
                        </div>

                        <div class="d-grid">
                            <% if (isAvailable) { %>
                                <% if (isKtpUploaded) { %>
                                    <a href="checkout.jsp?idKamar=<%= k.getIdKamar() %>" class="btn btn-gold py-2">
                                        Pesan Sekarang
                                    </a>
                                <% } else { %>
                                    <button class="btn btn-secondary py-2" disabled>Lengkapi KTP Dulu</button>
                                <% } %>
                            <% } else { %>
                                <button class="btn btn-light text-muted border py-2" disabled>
                                    <i class="fa-solid fa-ban me-1"></i> <%= k.getStatusKamar() %>
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% 
                    } 
                } else { 
            %>
            <div class="col-12 text-center py-5">
                <h5 class="text-muted">Belum ada kamar yang tersedia.</h5>
            </div>
            <% } %>
        </div>
    </div>

    <% } else { %>
        <div class="container mt-5 text-center">
            <h3 class="text-muted">Data Kos Tidak Ditemukan</h3>
            <a href="index.jsp" class="btn btn-primary mt-3">Kembali</a>
        </div>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>