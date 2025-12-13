<%-- 
    Document   : tambah-kos
    Created on : 13 Dec 2025, 23.38.06
    Author     : andin
--%>

<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // CEK KEAMANAN: Hanya Pemilik Kos yang boleh akses
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PEMILIK".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Kos Baru | E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-primary shadow-sm mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1"><i class="fa-solid fa-plus-circle me-2"></i>Tambah Properti</span>
            <a href="dashboard-pemilik.jsp" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Kembali ke Dashboard
            </a>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0 fw-bold text-primary">Form Data Kos</h5>
                    </div>
                    <div class="card-body p-4">
                        
                        <form action="properti" method="POST">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Nama Kos</label>
                                <input type="text" name="namaKos" class="form-control" placeholder="Contoh: Kos Melati Indah" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Alamat Lengkap</label>
                                <textarea name="alamatKos" class="form-control" rows="3" placeholder="Jl. Telekomunikasi No. 1..." required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Peraturan Kos</label>
                                <textarea name="peraturan" class="form-control" rows="4" placeholder="- Dilarang membawa hewan peliharaan&#10;- Jam malam pukul 22.00"></textarea>
                                <div class="form-text">Tuliskan peraturan poin per poin agar mudah dibaca.</div>
                            </div>

                            <hr>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="dashboard-pemilik.jsp" class="btn btn-secondary">Batal</a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-save me-1"></i> Simpan Properti
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
