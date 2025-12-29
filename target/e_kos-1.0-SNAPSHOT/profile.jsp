<%-- 
    Document   : profile
    Created on : 14 Dec 2025
--%>

<%@page import="model.Penyewa"%>
<%@page import="model.PemilikKos"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String role = user.getRole();
    String nama = user.getNamaPanggilan();
    String email = user.getEmail();
    String noHp = "-";
    String docPath = null;
    String docLabel = "";
    String inputName = "";
    String backLink = "";
    
    if ("PEMILIK".equals(role)) {
        PemilikKos p = (PemilikKos) user;
        noHp = p.getNoHp();
        docPath = p.getSkPath();
        docLabel = "Surat Kepemilikan (SK)";
        inputName = "fileSK";
        backLink = "dashboard-pemilik.jsp";
    } else {
        Penyewa p = (Penyewa) user;
        noHp = p.getNoHp();
        docPath = p.getKtpPath();
        docLabel = "Kartu Tanda Penduduk (KTP)";
        inputName = "fileKTP";
        backLink = "index.jsp";
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Profile <%= role %> | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #0d2c56; }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-custom shadow-sm mb-5">
        <div class="container">
            <span class="navbar-brand mb-0 h1">Profil Saya</span>
            <a href="<%= backLink %>" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Kembali ke Dashboard
            </a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                
                <% if ("success".equals(request.getParameter("status"))) { %>
                    <div class="alert alert-success shadow-sm border-0">
                        <i class="fa-solid fa-circle-check me-2"></i> Dokumen berhasil diunggah!
                    </div>
                <% } else if ("db_error".equals(request.getParameter("status"))) { %>
                    <div class="alert alert-danger shadow-sm border-0">Gagal menyimpan ke database.</div>
                <% } %>

                <div class="card shadow border-0 overflow-hidden">
                    <div class="card-header bg-white py-3 border-bottom">
                        <h5 class="mb-0 fw-bold text-dark"><i class="fa-solid fa-user-circle me-2"></i>Informasi Akun</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px;">
                                <i class="fa-solid fa-user fa-2x text-secondary"></i>
                            </div>
                            <h5 class="mt-3 fw-bold"><%= nama %></h5>
                            <span class="badge bg-info text-dark"><%= role %></span>
                        </div>

                        <div class="list-group list-group-flush mb-4">
                            <div class="list-group-item d-flex justify-content-between px-0">
                                <span class="text-muted">Email</span>
                                <span class="fw-semibold"><%= email %></span>
                            </div>
                            <div class="list-group-item d-flex justify-content-between px-0">
                                <span class="text-muted">Nomor HP</span>
                                <span class="fw-semibold"><%= (noHp != null) ? noHp : "-" %></span>
                            </div>
                        </div>

                        <div class="card bg-light border-0">
                            <div class="card-body">
                                <h6 class="fw-bold mb-3"><i class="fa-solid fa-file-contract me-2"></i>Verifikasi Dokumen</h6>
                                <label class="form-label small text-muted"><%= docLabel %></label>

                                <% if (docPath != null && !docPath.isEmpty()) { %>
                                    <div class="mb-3">
                                        <div class="d-flex align-items-center p-2 bg-white rounded border">
                                            <i class="fa-solid fa-check-circle text-success fa-lg me-3"></i>
                                            <div>
                                                <div class="fw-bold text-success small">Terverifikasi</div>
                                                <small class="text-muted">Dokumen sudah diunggah.</small>
                                            </div>
                                        </div>
                                        <img src="uploads/<%= docPath %>" class="img-fluid rounded mt-2 border" style="max-height: 150px;">
                                    </div>
                                    <p class="small text-muted mb-2">Ingin memperbarui dokumen?</p>
                                <% } else { %>
                                    <div class="alert alert-warning small border-0">
                                        <i class="fa-solid fa-triangle-exclamation me-1"></i> 
                                        Anda belum mengunggah dokumen. Mohon lengkapi segera.
                                    </div>
                                <% } %>

                                <form action="updateProfile" method="post" enctype="multipart/form-data">
                                    <div class="input-group">
                                        <input type="file" name="<%= inputName %>" class="form-control" accept="image/*" required>
                                        <button class="btn btn-primary" type="submit" style="background-color: var(--primary-color);">Upload</button>
                                    </div>
                                    <div class="form-text small">Format: JPG/PNG. Maks 5MB.</div>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>