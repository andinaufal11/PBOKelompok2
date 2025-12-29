<%-- 
    Document   : tambah-kos
    Created on : 13 Dec 2025
--%>

<%@page import="model.Pengguna"%>
<%@page import="model.PemilikKos"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Pengguna user = (Pengguna) session.getAttribute("user");

    // 1. CEK LOGIN & ROLE
    if (user == null || !"PEMILIK".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. CEK APAKAH SUDAH UPLOAD SK? (Logic Gate)
    if (user instanceof PemilikKos) {
        PemilikKos p = (PemilikKos) user;
        if (p.getSkPath() == null || p.getSkPath().trim().isEmpty()) {
            response.sendRedirect("profile.jsp?alert=wajib_sk");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Tambah Properti | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #0d2c56; }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }
        .card-header-custom { background-color: white; border-bottom: 2px solid var(--primary-color); }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark navbar-custom shadow-sm mb-5">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold"><i class="fa-solid fa-plus-circle me-2"></i>Tambah Properti</span>
            <a href="dashboard-pemilik.jsp" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Kembali ke Dashboard
            </a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                
                <div class="card shadow border-0">
                    <div class="card-header card-header-custom py-3">
                        <h5 class="mb-0 fw-bold" style="color: var(--primary-color);">Data Kos Baru</h5>
                    </div>
                    
                    <div class="card-body p-4 p-md-5">
                        <div class="alert alert-info d-flex align-items-center mb-4 border-0 bg-info-subtle text-info-emphasis">
                            <i class="fa-solid fa-circle-info me-3 fa-lg"></i>
                            <div>
                                <strong>Info:</strong> Pastikan data yang Anda masukkan valid dan foto bangunan terlihat jelas agar menarik minat penyewa.
                            </div>
                        </div>

                        <form action="properti" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Nama Kos</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="fa-solid fa-sign-hanging"></i></span>
                                    <input type="text" name="namaKos" class="form-control" placeholder="Contoh: Kos Melati Indah" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Foto Depan Bangunan</label>
                                <input type="file" name="fotoKos" class="form-control" accept="image/*" required>
                                <div class="form-text text-muted"><i class="fa-solid fa-camera me-1"></i> Format: JPG/PNG. Maks 5MB.</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Alamat Lengkap</label>
                                <textarea name="alamatKos" class="form-control" rows="3" placeholder="Jl. Telekomunikasi No. 1, Bojongsoang..." required></textarea>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Peraturan & Ketentuan</label>
                                <textarea name="peraturan" class="form-control" rows="5" placeholder="- Dilarang membawa hewan peliharaan&#10;- Jam malam tamu pukul 22.00&#10;- Listrik token masing-masing"></textarea>
                                <div class="form-text">Gunakan baris baru untuk memisahkan poin peraturan.</div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end pt-3 border-top">
                                <a href="dashboard-pemilik.jsp" class="btn btn-light border px-4">Batal</a>
                                <button type="submit" class="btn btn-primary px-4 fw-bold" style="background-color: var(--primary-color); border:none;">
                                    <i class="fa-solid fa-paper-plane me-1"></i> Simpan Properti
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>