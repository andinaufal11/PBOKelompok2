<%-- 
    Document   : index
    Created on : 13 Dec 2025, 23.32.27
    Author     : andin
--%>

<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // CEK KEAMANAN: Apakah user sudah login?
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PENYEWA".equals(user.getRole())) {
        response.sendRedirect("login.jsp"); // Kalau belum login/salah role, tendang keluar
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beranda Penyewa | E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-house-chimney me-2"></i>E-Kos</a>
            <div class="d-flex align-items-center">
                <span class="text-white me-3">Halo, <strong><%= user.getNamaPanggilan() %></strong>!</span>
                <a href="login?action=logout" class="btn btn-outline-light btn-sm"><i class="fa-solid fa-sign-out-alt me-1"></i>Keluar</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="p-5 mb-4 bg-white rounded-3 shadow-sm text-center">
            <h1 class="display-5 fw-bold text-success">Cari Kos Impianmu</h1>
            <p class="col-md-8 fs-4 mx-auto">Temukan ribuan pilihan kos nyaman, aman, dan terjangkau di sekitarmu.</p>
            
            <div class="row justify-content-center mt-4">
                <div class="col-md-6">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control form-control-lg" placeholder="Mau cari kos di daerah mana?">
                        <button class="btn btn-success btn-lg" type="button"><i class="fa-solid fa-search"></i> Cari</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
