<%-- 
    Document   : dashboard-pemilik.jsp
    Created on : 13 Dec 2025
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.PropertiDAO"%>
<%@page import="model.PropertiKos"%>
<%@page import="model.Pengguna"%>
<%@page import="model.PemilikKos"%>
<%@page import="dao.TransaksiDAO"%>      
<%@page import="model.TransaksiSewa"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. CEK SESSION LOGIN
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PEMILIK".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. CEK STATUS UPLOAD SK
    boolean sudahUploadSK = false;
    if (user instanceof PemilikKos) {
        PemilikKos p = (PemilikKos) user;
        if (p.getSkPath() != null && !p.getSkPath().trim().isEmpty()) {
            sudahUploadSK = true;
        }
    }

    // 3. AMBIL DATA PROPERTI
    PropertiDAO dao = new PropertiDAO();
    List<PropertiKos> listProperti = dao.getPropertiByPemilik(user.getIdPengguna());
    
    // 4. AMBIL NOTIFIKASI PERMINTAAN SEWA
    TransaksiDAO transDao = new TransaksiDAO();
    List<TransaksiSewa> listRequest = transDao.getPermintaanSewa(user.getIdPengguna());
    if (listRequest == null) listRequest = new ArrayList<>(); // Mencegah null pointer

    String status = request.getParameter("status");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Pemilik | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #0d2c56; /* Navy */
            --accent-color: #fca311;  /* Gold */
        }
        body { background-color: #f4f6f9; }
        
        /* Navbar Styling */
        .navbar-custom { background-color: var(--primary-color); }
        
        /* Sidebar Styling */
        .sidebar { min-height: 100vh; background-color: white; border-right: 1px solid #dee2e6; }
        .sidebar .list-group-item { border: none; color: #6c757d; padding: 12px 20px; font-weight: 500; }
        .sidebar .list-group-item:hover { background-color: #f8f9fa; color: var(--primary-color); }
        .sidebar .list-group-item.active { 
            background-color: #eef2f7; 
            color: var(--primary-color); 
            border-left: 4px solid var(--primary-color);
            border-radius: 0;
        }
        
        /* Card Styling */
        .card-properti { border: none; border-radius: 8px; transition: all 0.3s; }
        .card-properti:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
        .badge-kamar { background-color: #eef2f7; color: var(--primary-color); font-weight: bold; }
        
        /* Gold Button */
        .btn-gold { background-color: var(--accent-color); color: #000; font-weight: bold; border: none; }
        .btn-gold:hover { background-color: #e0910f; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-building-user me-2"></i>Mitra E-Kos</a>
            <div class="d-flex align-items-center text-white">
                <div class="text-end me-3 d-none d-md-block">
                    <small class="d-block text-white-50" style="font-size: 0.75rem;">Login sebagai</small>
                    <span class="fw-semibold"><%= user.getNamaPanggilan() %></span>
                </div>
                <a href="login?action=logout" class="btn btn-outline-light btn-sm rounded-pill px-3">Keluar</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            
            <div class="col-md-3 col-lg-2 px-0 sidebar d-none d-md-block shadow-sm">
                <div class="py-4">
                    <div class="list-group list-group-flush">
                        <div class="px-3 mb-2 text-muted small text-uppercase fw-bold">Menu Utama</div>
                        
                        <a href="dashboard-pemilik.jsp" class="list-group-item active">
                            <i class="fa-solid fa-house me-2"></i> Dashboard
                        </a>
                        
                        <a href="konfirmasi.jsp" class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fa-solid fa-inbox me-2"></i> Permintaan Sewa</span>
                            <% if (listRequest.size() > 0) { %>
                                <span class="badge bg-danger rounded-pill"><%= listRequest.size() %></span>
                            <% } %>
                        </a>
                        
                        <a href="data-penghuni.jsp" class="list-group-item">
                            <i class="fa-solid fa-users me-2"></i> Data Penghuni
                        </a>
                        
                        <a href="laporan-pemilik.jsp" class="list-group-item">
                            <i class="fa-solid fa-chart-line me-2"></i> Laporan
                        </a>
                        
                        <div class="px-3 mt-4 mb-2 text-muted small text-uppercase fw-bold">Pengaturan</div>
                        <a href="profile.jsp" class="list-group-item">
                            <i class="fa-solid fa-user-gear me-2"></i> Akun & SK
                        </a>
                    </div>
                </div>
            </div>

            <main class="col-md-9 col-lg-10 ms-sm-auto px-md-4 py-4">
                
                <%-- NOTIFIKASI ALERT --%>
                <% if ("added".equals(status)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-check-circle me-2"></i> Properti kos berhasil ditambahkan!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if ("updated".equals(status)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-check-circle me-2"></i> Data properti berhasil diperbarui!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if ("deleted".equals(status)) { %>
                    <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fa-solid fa-trash me-2"></i> Properti telah dihapus.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if ("error_delete".equals(status)) { %>
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <strong>Gagal!</strong> Properti masih memiliki data terkait (Kamar/Transaksi).
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-3 mb-4 border-bottom">
                    <div>
                        <h1 class="h3 fw-bold text-dark">Properti Saya</h1>
                        <p class="text-muted mb-0">Kelola daftar kos yang Anda sewakan.</p>
                    </div>
                    
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <% if (sudahUploadSK) { %>
                            <a href="tambah-kos.jsp" class="btn btn-gold shadow-sm">
                                <i class="fa-solid fa-plus me-1"></i> Tambah Properti
                            </a>
                        <% } else { %>
                            <a href="profile.jsp" class="btn btn-warning text-dark fw-bold shadow-sm">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i> Lengkapi SK Dulu
                            </a>
                        <% } %>
                    </div>
                </div>

                <% if (listProperti.isEmpty()) { %>
                    <div class="text-center py-5 bg-white rounded shadow-sm border">
                        <div class="opacity-25 mb-3"><i class="fa-solid fa-city fa-4x"></i></div>
                        <h5 class="text-muted">Belum ada properti.</h5>
                        <p class="text-secondary small">Klik tombol tambah di pojok kanan atas untuk memulai.</p>
                    </div>
                <% } else { %>
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <% for (PropertiKos p : listProperti) { %>
                        <div class="col">
                            <div class="card h-100 card-properti bg-white shadow-sm">
                                <div style="height: 180px; overflow: hidden; position: relative;">
                                    <img src="images/<%= p.getFotoKos() %>" class="w-100 h-100" style="object-fit: cover;"
                                         alt="<%= p.getNamaKos() %>" onerror="this.src='https://placehold.co/600x400?text=No+Image';">
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <span class="badge bg-white text-dark shadow-sm"><i class="fa-solid fa-star text-warning"></i> 4.8</span>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <h5 class="card-title fw-bold text-dark mb-1"><%= p.getNamaKos() %></h5>
                                    <p class="text-muted small mb-3">
                                        <i class="fa-solid fa-location-dot me-1 text-danger"></i> 
                                        <%= (p.getAlamatKos().length() > 30) ? p.getAlamatKos().substring(0, 30) + "..." : p.getAlamatKos() %>
                                    </p>
                                    
                                    <div class="d-flex justify-content-between align-items-center bg-light rounded p-2 mb-3">
                                        <span class="small text-muted">Total Kamar</span>
                                        <span class="badge-kamar px-2 py-1 rounded small"><%= p.getJumlahKamar() %> Unit</span>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <a href="kelola-kamar.jsp?id_kos=<%= p.getIdKos() %>" class="btn btn-outline-primary btn-sm">
                                            <i class="fa-solid fa-bed me-1"></i> Kelola Kamar
                                        </a>
                                        <div class="btn-group">
                                            <a href="properti?action=edit&id=<%= p.getIdKos() %>" class="btn btn-outline-secondary btn-sm">Edit</a>
                                            <a href="properti?action=delete&id=<%= p.getIdKos() %>" class="btn btn-outline-danger btn-sm" 
                                               onclick="return confirm('Yakin hapus data ini?')">Hapus</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } %>

            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>