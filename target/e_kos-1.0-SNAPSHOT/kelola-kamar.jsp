<%-- 
    Document   : kelola-kamar
    Created on : 14 Dec 2025
    Author     : Fachrul Rozi
--%>

<%@page import="java.util.List"%>
<%@page import="dao.KamarDAO"%>
<%@page import="model.Kamar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String idKosStr = request.getParameter("id_kos");
    if (idKosStr == null || idKosStr.isEmpty()) {
        response.sendRedirect("dashboard-pemilik.jsp");
        return;
    }
    int idKos = Integer.parseInt(idKosStr);
    
    KamarDAO dao = new KamarDAO();
    List<Kamar> listKamar = dao.getKamarByKos(idKos);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Kelola Kamar | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #0d2c56; /* Navy */
            --accent-color: #fca311;  /* Gold */
        }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }
        .btn-gold { background-color: var(--accent-color); color: #000; font-weight: bold; border: none; }
        .btn-gold:hover { background-color: #e0910f; }
        .table thead th { background-color: var(--primary-color); color: white; border: none; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark navbar-custom shadow-sm mb-4">
        <div class="container">
            <span class="navbar-brand mb-0 h1 fw-bold"><i class="fa-solid fa-bed me-2"></i>Manajemen Kamar</span>
            <a href="dashboard-pemilik.jsp" class="btn btn-outline-light btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Kembali ke Dashboard
            </a>
        </div>
    </nav>

    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold text-dark">Daftar Kamar</h4>
                <p class="text-muted mb-0">Kelola ketersediaan dan harga kamar di properti ini.</p>
            </div>
            <button type="button" class="btn btn-gold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalTambah">
                <i class="fa-solid fa-plus me-1"></i> Tambah Kamar
            </button>
        </div>

        <div class="card shadow border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Foto</th> 
                                <th>No. Kamar</th>
                                <th>Tipe</th>
                                <th>Detail Info</th> 
                                <th>Harga/Bulan</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listKamar.isEmpty()) { %>
                                <tr><td colspan="7" class="text-center text-muted py-5">
                                    <i class="fa-solid fa-door-open fa-3x mb-3 opacity-25"></i><br>
                                    Belum ada data kamar. Silakan tambah baru.
                                </td></tr>
                            <% } else { 
                                 for (Kamar k : listKamar) { %>
                                <tr>
                                    <td class="ps-4">
                                        <img src="images/<%= k.getFotoKamar() %>" 
                                             alt="Foto" 
                                             class="rounded shadow-sm"
                                             style="width: 60px; height: 50px; object-fit: cover;"
                                             onerror="this.src='https://placehold.co/60x50?text=No+Img';">
                                    </td>
                                    
                                    <td class="fw-bold fs-5 text-secondary"><%= k.getNomorKamar() %></td>
                                    
                                    <td>
                                        <% if("VIP".equalsIgnoreCase(k.getTipeSpesifik())) { %>
                                            <span class="badge bg-warning text-dark"><i class="fa-solid fa-crown me-1"></i>VIP</span>
                                        <% } else { %>
                                            <span class="badge bg-light text-dark border">Standard</span>
                                        <% } %>
                                    </td>
                                    
                                    <td class="small text-muted" style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                        <%= k.getFasilitas() %>
                                    </td>
                                    
                                    <td class="fw-bold text-primary">Rp <%= String.format("%,.0f", k.getHargaBulanan()) %></td>
                                    
                                    <td>
                                        <% String st = k.getStatusKamar(); 
                                           if("Tersedia".equalsIgnoreCase(st)) { %>
                                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Tersedia</span>
                                        <% } else if("Perbaikan".equalsIgnoreCase(st)) { %>
                                            <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Perbaikan</span>
                                        <% } else { %>
                                            <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Terisi</span>
                                        <% } %>
                                    </td>
                                    
                                    <td class="text-center">
                                        <div class="btn-group">
                                            <a href="edit-kamar.jsp?id=<%= k.getIdKamar() %>" class="btn btn-sm btn-outline-secondary" title="Edit">
                                                <i class="fa-solid fa-pen"></i>
                                            </a>
                                            <a href="kamar?action=delete&id=<%= k.getIdKamar() %>&idKos=<%= k.getIdKos() %>" 
                                               class="btn btn-sm btn-outline-danger"
                                               title="Hapus"
                                               onclick="return confirm('Yakin ingin menghapus kamar ini?');">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalTambah" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="kamar" method="POST" enctype="multipart/form-data">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold"><i class="fa-solid fa-plus-circle me-2"></i>Tambah Kamar Baru</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="idKos" value="<%= idKos %>">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Nomor Kamar</label>
                                <input type="text" name="noKamar" class="form-control" placeholder="Contoh: 101, A1" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Harga per Bulan (Rp)</label>
                                <input type="number" name="harga" class="form-control" placeholder="Contoh: 1500000" required>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label fw-semibold">Foto Kamar</label>
                                <input type="file" name="fotoKamar" class="form-control" accept="image/*" required>
                            </div>

                            <div class="col-md-12">
                                <label class="form-label fw-semibold">Tipe Kamar</label>
                                <select name="tipe" id="pilihTipe" class="form-select" onchange="cekTipe()">
                                    <option value="Standard">Standard (Reguler)</option>
                                    <option value="VIP">VIP (Eksklusif)</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <div id="blokReguler" class="p-3 bg-light border rounded">
                                    <label class="text-secondary fw-bold small mb-2"><i class="fa-solid fa-bed"></i> Detail Standard</label>
                                    <div class="row g-2">
                                        <div class="col-6"><input type="text" name="ukuran" class="form-control form-control-sm" placeholder="Ukuran (3x3 m)"></div>
                                        <div class="col-6"><input type="text" name="jenisKasur" class="form-control form-control-sm" placeholder="Jenis Kasur (Single)"></div>
                                    </div>
                                </div>

                                <div id="blokVIP" class="p-3 bg-info bg-opacity-10 border border-info rounded" style="display:none;">
                                    <label class="text-primary fw-bold small mb-2"><i class="fa-solid fa-crown"></i> Detail Eksklusif</label>
                                    <div class="row g-2">
                                        <div class="col-6"><input type="text" name="luasArea" class="form-control form-control-sm" placeholder="Luas Area (4x5 m)"></div>
                                        <div class="col-6"><input type="text" name="fasilitasTambahan" class="form-control form-control-sm" placeholder="Extra (AC, TV, dll)"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Fasilitas Lengkap</label>
                                <textarea name="fasilitas" class="form-control" rows="3" placeholder="Sebutkan semua fasilitas di sini..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-primary px-4">Simpan Data</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function cekTipe() {
            var tipe = document.getElementById("pilihTipe").value;
            var blokReguler = document.getElementById("blokReguler");
            var blokVIP = document.getElementById("blokVIP");
            
            if (tipe === "VIP") {
                blokReguler.style.display = "none";
                blokVIP.style.display = "block";
            } else {
                blokReguler.style.display = "block";
                blokVIP.style.display = "none";
            }
        }
        window.onload = cekTipe; 
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>