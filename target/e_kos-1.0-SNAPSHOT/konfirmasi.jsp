<%-- 
    Document   : konfirmasi.jsp
    Function   : Halaman ACC Permintaan Sewa (Dengan Sidebar)
--%>
<%@page import="model.Penyewa"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="dao.TransaksiDAO"%>
<%@page import="model.TransaksiSewa"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PEMILIK".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TransaksiDAO dao = new TransaksiDAO();
    List<TransaksiSewa> listRequest = dao.getPermintaanSewa(user.getIdPengguna());
    Locale localeID = new Locale("in", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Permintaan Sewa | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #0d2c56; --accent-color: #fca311; }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }
        .sidebar { min-height: 100vh; background-color: white; border-right: 1px solid #dee2e6; }
        .sidebar .list-group-item { border: none; color: #6c757d; padding: 12px 20px; font-weight: 500; }
        .sidebar .list-group-item:hover { background-color: #f8f9fa; color: var(--primary-color); }
        .sidebar .list-group-item.active { background-color: #eef2f7; color: var(--primary-color); border-left: 4px solid var(--primary-color); border-radius: 0; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-building-user me-2"></i>Mitra E-Kos</a>
            <div class="d-flex align-items-center text-white">
                <span class="me-3 d-none d-md-block">Owner: <strong><%= user.getNamaPanggilan() %></strong></span>
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
                        <a href="dashboard-pemilik.jsp" class="list-group-item">
                            <i class="fa-solid fa-house me-2"></i> Dashboard
                        </a>
                        <a href="konfirmasi.jsp" class="list-group-item active">
                            <i class="fa-solid fa-inbox me-2"></i> Permintaan Sewa
                            <% if(listRequest.size() > 0) { %>
                                <span class="badge bg-danger rounded-pill float-end"><%= listRequest.size() %></span>
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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold text-dark">Permintaan Masuk</h3>
                        <p class="text-muted mb-0">Setujui atau tolak permintaan sewa yang masuk.</p>
                    </div>
                </div>

                <div class="card shadow border-0">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead style="background-color: var(--primary-color); color: white;">
                                    <tr>
                                        <th class="p-3">Tanggal Masuk</th>
                                        <th>Calon Penyewa</th>
                                        <th>Kamar Diminta</th>
                                        <th>Durasi</th>
                                        <th>Total Biaya</th>
                                        <th class="text-center">Aksi Konfirmasi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listRequest.isEmpty()) { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-5">
                                                <div class="opacity-25 mb-3 display-4"><i class="fa-solid fa-clipboard-check"></i></div>
                                                <h5 class="text-muted">Semua bersih!</h5>
                                                <p class="text-muted small">Tidak ada permintaan sewa baru saat ini.</p>
                                            </td>
                                        </tr>
                                    <% } else { 
                                        for (TransaksiSewa t : listRequest) {
                                            Penyewa p = (Penyewa) t.getPenyewa();
                                    %>
                                    <tr>
                                        <td class="p-3"><%= t.getTanggalMulai() %></td>
                                        <td>
                                            <div class="fw-bold"><%= p.getNamaPanggilan() %></div>
                                            <small class="text-muted"><i class="fa-brands fa-whatsapp text-success"></i> <%= p.getNoHp() %></small>
                                        </td>
                                        <td><span class="badge bg-info text-dark">Kamar <%= t.getKamar().getNomorKamar() %></span></td>
                                        <td><%= t.getDurasiSewa() %> Bulan</td>
                                        <td class="fw-bold text-primary"><%= formatRupiah.format(t.getTotalBayar()) %></td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="prosesBooking?action=terima&id=<%= t.getIdTransaksi() %>&idKamar=<%= t.getKamar().getIdKamar() %>&source=konfirmasi" 
                                                   class="btn btn-success btn-sm fw-bold px-3 shadow-sm"
                                                   onclick="return confirm('Terima penyewa ini?')">
                                                    <i class="fa-solid fa-check me-1"></i> Terima
                                                </a>
                                                <a href="prosesBooking?action=tolak&id=<%= t.getIdTransaksi() %>&idKamar=<%= t.getKamar().getIdKamar() %>&source=konfirmasi" 
                                                   class="btn btn-danger btn-sm fw-bold px-3 shadow-sm"
                                                   onclick="return confirm('Tolak permintaan ini?')">
                                                    <i class="fa-solid fa-xmark me-1"></i> Tolak
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
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>