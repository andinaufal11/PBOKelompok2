<%-- 
    Document   : edit-kamar
    Created on : 14 Dec 2025
--%>

<%@page import="dao.KamarDAO"%>
<%@page import="model.Kamar"%>
<%
    String idStr = request.getParameter("id");
    if(idStr == null) { response.sendRedirect("dashboard-pemilik.jsp"); return; }
    
    KamarDAO dao = new KamarDAO();
    Kamar k = dao.getKamarById(Integer.parseInt(idStr));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Kamar | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root { --primary-color: #0d2c56; }
        body { background-color: #f4f6f9; }
        .card-header-custom { background-color: var(--primary-color); color: white; }
    </style>
</head>
<body class="py-5">
    <div class="container" style="max-width: 700px;">
        <div class="card shadow border-0">
            <div class="card-header card-header-custom py-3">
                <h5 class="mb-0 fw-bold">Edit Data Kamar</h5>
            </div>
            <div class="card-body p-4">
                
                <form action="kamar" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="idKamar" value="<%= k.getIdKamar() %>">
                    <input type="hidden" name="idKos" value="<%= k.getIdKos() %>">
                    <input type="hidden" name="fotoLama" value="<%= k.getFotoKamar() %>">
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Nomor Kamar</label>
                            <input type="text" name="noKamar" class="form-control" value="<%= k.getNomorKamar() %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Harga per Bulan (Rp)</label>
                            <input type="number" name="harga" class="form-control" value="<%= String.format("%.0f", k.getHargaBulanan()) %>" required>
                        </div>

                        <div class="col-12 mt-3">
                            <label class="form-label fw-semibold">Foto Kamar</label>
                            <div class="d-flex align-items-center mb-2 p-2 border rounded bg-light">
                                <img src="images/<%= k.getFotoKamar() %>" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;" onerror="this.src='https://placehold.co/60x60?text=No+Img';">
                                <div class="small text-muted">Gambar saat ini. Upload baru jika ingin mengubah.</div>
                            </div>
                            <input type="file" name="fotoKamar" class="form-control" accept="image/*">
                        </div>
                        
                        <div class="col-12 mt-3">
                            <label class="form-label fw-semibold">Fasilitas</label>
                            <textarea name="fasilitas" class="form-control" rows="4"><%= k.getFasilitas() %></textarea>
                            <div class="form-text">Contoh: Kasur, Lemari, WiFi, Kamar Mandi Dalam.</div>
                        </div>
                        
                        <div class="col-12 mt-3">
                            <label class="form-label fw-semibold">Status Kamar</label>
                            <select name="status" class="form-select">
                                <option value="Tersedia" <%= "Tersedia".equals(k.getStatusKamar()) ? "selected" : "" %>>Tersedia</option>
                                <option value="Terisi" <%= "Terisi".equals(k.getStatusKamar()) ? "selected" : "" %>>Terisi</option>
                                <option value="Perbaikan" <%= "Perbaikan".equals(k.getStatusKamar()) ? "selected" : "" %>>Perbaikan</option>
                            </select>
                        </div>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="d-flex justify-content-end gap-2">
                        <a href="kelola-kamar.jsp?id_kos=<%= k.getIdKos() %>" class="btn btn-light border px-4">Batal</a>
                        <button type="submit" class="btn btn-primary px-4" style="background-color: var(--primary-color);">Simpan Perubahan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>