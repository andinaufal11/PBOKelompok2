<%-- 
    Document   : index
    Created on : 13 Dec 2025
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.PropertiKos"%>
<%@page import="dao.PropertiDAO"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PENYEWA".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    PropertiDAO dao = new PropertiDAO();
    String keyword = request.getParameter("keyword");
    List<PropertiKos> listKos = dao.getAllProperti(keyword);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beranda Penyewa | E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #0d2c56; /* Navy */
            --accent-color: #fca311;  /* Gold */
            --bg-color: #f4f6f9;
        }
        body { background-color: var(--bg-color); }
        
        .navbar-custom { background-color: var(--primary-color); }
        
        /* Hero Section for Search */
        .hero-section {
            background: linear-gradient(rgba(13, 44, 86, 0.9), rgba(13, 44, 86, 0.8)), url('https://images.unsplash.com/photo-1556020685-ae41abfc9365?q=80&w=1000&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 4rem 1rem;
            border-radius: 0 0 20px 20px;
            margin-bottom: 2rem;
        }
        
        .btn-search {
            background-color: var(--accent-color);
            color: #000;
            border: none;
            font-weight: bold;
        }
        .btn-search:hover { background-color: #e0910f; }
        
        .card-kos {
            border: none;
            border-radius: 12px;
            transition: transform 0.3s;
            overflow: hidden;
            background: white;
        }
        .card-kos:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .kos-img { height: 200px; object-fit: cover; }
        .btn-outline-primary-custom {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .btn-outline-primary-custom:hover {
            background-color: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp"><i class="fa-solid fa-building me-2"></i>E-Kos</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <div class="navbar-nav ms-auto align-items-center">
                    <a href="riwayat-sewa.jsp" class="nav-link text-white me-3">
                        <i class="fa-solid fa-clock-rotate-left me-1"></i> Riwayat
                    </a>
                    <a href="profile.jsp" class="nav-link text-white me-3">
                        <i class="fa-solid fa-user me-1"></i> Akun
                    </a>
                    <span class="text-white-50 mx-2">|</span>
                    <span class="text-white me-3 small">Hai, <%= user.getNamaPanggilan() %></span>
                    <a href="login?action=logout" class="btn btn-outline-light btn-sm rounded-pill px-3">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="hero-section text-center">
        <div class="container">
            <h1 class="display-6 fw-bold mb-3">Temukan Kos Idamanmu</h1>
            <p class="mb-4 text-light opacity-75">Cari berdasarkan nama kos atau lokasi terdekat</p>
            <form action="index.jsp" method="GET" class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="input-group input-group-lg shadow-sm">
                        <input type="text" name="keyword" class="form-control border-0" 
                               placeholder="Contoh: Kos Melati, Bandung..." value="<%= (keyword != null) ? keyword : "" %>">
                        <button class="btn btn-search px-4" type="submit"><i class="fa-solid fa-search"></i> Cari</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="container mb-5">
        <div class="d-flex align-items-center mb-4">
            <div class="flex-grow-1">
                <h4 class="fw-bold text-dark mb-0">
                    <%= (keyword != null && !keyword.isEmpty()) ? "Hasil Pencarian: " + keyword : "Rekomendasi Terbaru" %>
                </h4>
            </div>
        </div>

        <div class="row g-4">
            <% 
                if (listKos != null && !listKos.isEmpty()) {
                    for (PropertiKos kos : listKos) {
            %>
            <div class="col-md-6 col-lg-4">
                <div class="card card-kos h-100 shadow-sm">
                    <img src="images/<%= kos.getFotoKos() %>" class="card-img-top kos-img" 
                         alt="Foto <%= kos.getNamaKos() %>"
                         onerror="this.src='https://placehold.co/600x400?text=No+Image';">
                    
                    <div class="card-body">
                        <h5 class="card-title fw-bold mb-1" style="color: var(--primary-color);"><%= kos.getNamaKos() %></h5>
                        <p class="text-muted small mb-3">
                            <i class="fa-solid fa-location-dot text-danger me-1"></i> <%= kos.getAlamatKos() %>
                        </p>
                        
                        <div class="d-flex align-items-center bg-light rounded p-2 mb-3 small text-secondary">
                            <i class="fa-solid fa-circle-info me-2 text-info"></i> 
                            <%= (kos.getPeraturan().length() > 30) ? kos.getPeraturan().substring(0, 30) + "..." : kos.getPeraturan() %>
                        </div>

                        <div class="d-grid">
                            <a href="detail-kos.jsp?id_kos=<%= kos.getIdKos() %>" class="btn btn-outline-primary-custom fw-semibold">
                                Lihat Detail & Kamar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <% 
                    } 
                } else { 
            %>
            <div class="col-12 text-center py-5">
                <div class="mb-3 text-muted"><i class="fa-solid fa-magnifying-glass fa-3x"></i></div>
                <h5 class="text-muted">Kos tidak ditemukan.</h5>
                <p class="small text-secondary">Coba gunakan kata kunci lain.</p>
            </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>