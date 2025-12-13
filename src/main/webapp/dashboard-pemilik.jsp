<%@page import="java.util.List"%>
<%@page import="dao.PropertiDAO"%>
<%@page import="model.PropertiKos"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. CEK KEAMANAN
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PEMILIK".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. AMBIL DATA DARI DATABASE (AGREGASI)
    // Memanggil DAO untuk mengambil daftar kos milik user yang sedang login
    PropertiDAO dao = new PropertiDAO();
    List<PropertiKos> listKos = dao.getPropertiByPemilik(user.getIdPengguna());
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Pemilik | E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-primary shadow-sm">
        <div class="container">
            <span class="navbar-brand mb-0 h1"><i class="fa-solid fa-tachometer-alt me-2"></i>Mitra E-Kos</span>
            <div class="d-flex align-items-center">
                <span class="text-white me-3">Owner: <strong><%= user.getNamaPanggilan() %></strong></span>
                <a href="login?action=logout" class="btn btn-outline-light btn-sm">Keluar</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        
        <% if ("added".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-check-circle me-1"></i> Properti kos berhasil ditambahkan!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <div class="col-md-3 mb-4">
                <div class="list-group shadow-sm">
                    <a href="#" class="list-group-item list-group-item-action active">
                        <i class="fa-solid fa-building me-2"></i> Kelola Properti
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <i class="fa-solid fa-chart-line me-2"></i> Laporan (Statistik)
                    </a>
                </div>
            </div>

            <div class="col-md-9">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                        <h5 class="mb-0 fw-bold text-primary">Daftar Properti Kos Anda</h5>
                        <a href="tambah-kos.jsp" class="btn btn-primary btn-sm">
                            <i class="fa-solid fa-plus me-1"></i> Tambah Kos Baru
                        </a>
                    </div>
                    <div class="card-body">
                        
                        <%-- LOGIKA TAMPILAN: Cek apakah list kosong atau ada isinya --%>
                        <% if (listKos == null || listKos.isEmpty()) { %>
                            
                            <div class="text-center py-5 text-muted">
                                <i class="fa-regular fa-folder-open fa-3x mb-3"></i>
                                <p>Anda belum memiliki properti kos yang terdaftar.</p>
                                <p class="small">Silakan klik tombol <strong>Tambah Kos Baru</strong> untuk memulai.</p>
                            </div>

                        <% } else { %>
                            
                            <div class="row">
                                <% for (PropertiKos p : listKos) { %>
                                    <div class="col-md-6 mb-3">
                                        <div class="card h-100 border-primary">
                                            <div class="card-body">
                                                <h5 class="card-title fw-bold text-dark"><%= p.getNamaKos() %></h5>
                                                <h6 class="card-subtitle mb-2 text-muted">
                                                    <i class="fa-solid fa-map-marker-alt me-1"></i> 
                                                    ID Kos: #<%= p.getIdKos() %>
                                                </h6>
                                                <p class="card-text small text-secondary">
                                                    <%= p.getAlamatKos() %>
                                                </p>
                                                <hr>
                                                <p class="card-text small">
                                                    <strong>Peraturan:</strong><br>
                                                    <%= (p.getPeraturan() != null) ? p.getPeraturan() : "-" %>
                                                </p>
                                            </div>
                                            <div class="card-footer bg-white border-top-0 d-flex justify-content-between">
                                                <a href="#" class="btn btn-outline-primary btn-sm w-100">
                                                    <i class="fa-solid fa-door-open me-1"></i> Lihat Kamar
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>

                        <% } %>

                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>