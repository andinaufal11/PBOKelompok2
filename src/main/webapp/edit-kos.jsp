<%-- 
    Document   : edit-kos.jsp
    Created on : 14 Dec 2025
--%>

<%@page import="model.PropertiKos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    PropertiKos p = (PropertiKos) request.getAttribute("properti");
    if (p == null) {
        response.sendRedirect("dashboard-pemilik.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Edit Kos | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #0d2c56; }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark navbar-custom shadow-sm mb-5">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold"><i class="fa-solid fa-pen-to-square me-2"></i>Edit Properti Kos</span>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">
                
                <div class="card shadow border-0">
                    <div class="card-body p-4 p-md-5">
                        <h4 class="mb-4 text-dark fw-bold">Formulir Update Data</h4>
                        
                        <form action="properti" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="idKos" value="<%= p.getIdKos() %>">
                            <input type="hidden" name="fotoLama" value="<%= p.getFotoKos() %>">
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Kos</label>
                                <input type="text" name="namaKos" class="form-control" value="<%= p.getNamaKos() %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Foto Bangunan Utama</label>
                                <div class="d-flex align-items-center mb-2 p-2 bg-light border rounded">
                                    <img src="images/<%= p.getFotoKos() %>" class="rounded me-3" style="width: 80px; height: 60px; object-fit: cover;" onerror="this.src='https://placehold.co/80x60?text=No+Img';">
                                    <div class="small text-muted">Gambar saat ini</div>
                                </div>
                                <input type="file" name="fotoKos" class="form-control" accept="image/*">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Alamat Lengkap</label>
                                <textarea name="alamatKos" class="form-control" rows="3" required><%= p.getAlamatKos() %></textarea>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Peraturan & Ketentuan</label>
                                <textarea name="peraturan" class="form-control" rows="4" required><%= p.getPeraturan() %></textarea>
                            </div>
                            
                            <div class="d-flex justify-content-between pt-3 border-top">
                                <a href="dashboard-pemilik.jsp" class="btn btn-outline-secondary px-4">Batal</a>
                                <button type="submit" class="btn btn-primary px-4 fw-bold" style="background-color: var(--primary-color); border:none;">Simpan Perubahan</button>
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