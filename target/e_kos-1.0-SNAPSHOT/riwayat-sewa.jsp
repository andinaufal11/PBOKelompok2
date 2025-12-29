<%-- 
    Document   : riwayat-sewa.jsp
    Created on : 14 Dec 2025
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="dao.TransaksiDAO"%>
<%@page import="model.TransaksiSewa"%>
<%@page import="model.Pengguna"%>
<%@page import="model.Penyewa"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. CEK LOGIN
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PENYEWA".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. AMBIL DATA
    TransaksiDAO dao = new TransaksiDAO();
    List<TransaksiSewa> listSewa = dao.getRiwayatByPenyewa(user.getIdPengguna());

    Locale localeID = new Locale("in", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
    
    String statusParam = request.getParameter("status");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Riwayat Sewa | Mitra E-Kos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --primary-color: #0d2c56; --accent-color: #fca311; }
        body { background-color: #f4f6f9; }
        .navbar-custom { background-color: var(--primary-color); }
        .btn-gold { background-color: var(--accent-color); color: #000; font-weight: bold; border: none; }
        .btn-gold:hover { background-color: #e0910f; }
        
        /* Table Styling */
        .table thead th {
            background-color: var(--primary-color);
            color: white;
            border: none;
            font-weight: 500;
        }
        .status-badge { font-size: 0.85em; padding: 0.5em 0.8em; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom shadow-sm mb-5">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp"><i class="fa-solid fa-building me-2"></i>E-KOS</a>
            <div class="ms-auto d-flex align-items-center">
                <span class="text-white me-3 small">Halo, <%= user.getNamaPanggilan() %></span>
                <a href="login?action=logout" class="btn btn-sm btn-outline-light rounded-pill px-3">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container pb-5">
        
        <% if ("success".equals(statusParam)) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
            <div class="d-flex align-items-center">
                <i class="fa-solid fa-check-circle fa-2x me-3"></i>
                <div>
                    <strong>Booking Berhasil!</strong><br>
                    Permintaan Anda telah dikirim ke pemilik kos. Mohon tunggu konfirmasi atau lakukan pembayaran di tempat.
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } else if ("cancelled".equals(statusParam)) { %>
        <div class="alert alert-info alert-dismissible fade show shadow-sm border-0" role="alert">
            <i class="fa-solid fa-info-circle me-2"></i> Booking telah dibatalkan.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark"><i class="fa-solid fa-clock-rotate-left me-2"></i>Riwayat Sewa</h3>
                <p class="text-muted mb-0">Daftar transaksi sewa kamar yang pernah Anda lakukan.</p>
            </div>
            <a href="index.jsp" class="btn btn-gold shadow-sm">
                <i class="fa-solid fa-magnifying-glass me-1"></i> Cari Kos Lagi
            </a>
        </div>

        <div class="card shadow border-0 overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="p-3 ps-4">No</th>
                                <th>Detail Kamar</th>
                                <th>Tanggal Mulai</th>
                                <th>Durasi</th>
                                <th>Total Biaya</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (listSewa.isEmpty()) { 
                            %>
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <div class="text-muted opacity-25 mb-3"><i class="fa-solid fa-receipt fa-4x"></i></div>
                                        <h5 class="text-muted">Belum ada riwayat sewa.</h5>
                                        <a href="index.jsp" class="btn btn-sm btn-outline-primary mt-2">Mulai Menyewa</a>
                                    </td>
                                </tr>
                            <% 
                            } else {
                                int no = 1;
                                for (TransaksiSewa t : listSewa) {
                                    String st = t.getStatusPembayaran();
                            %>
                            <tr>
                                <td class="p-3 ps-4 fw-bold text-secondary"><%= no++ %></td>
                                
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light border rounded p-2 me-3 text-center" style="width: 50px;">
                                            <i class="fa-solid fa-bed text-primary"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold text-dark"><%= t.getKamar().getNamaKos() %></div>
                                            <small class="text-muted">Kamar No. <%= t.getKamar().getNomorKamar() %></small>
                                        </div>
                                    </div>
                                </td>

                                <td><%= t.getTanggalMulai() %></td>
                                <td><span class="badge bg-light text-dark border"><%= t.getDurasiSewa() %> Bulan</span></td>
                                <td class="fw-bold text-primary"><%= formatRupiah.format(t.getTotalBayar()) %></td>
                                
                                <td>
                                    <% if ("Booked".equalsIgnoreCase(st) || "Pending".equalsIgnoreCase(st) || "Menunggu Pembayaran".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-warning text-dark status-badge"><i class="fa-solid fa-clock me-1"></i> Menunggu Konfirmasi</span>
                                    <% } else if ("Aktif".equalsIgnoreCase(st) || "Lunas".equalsIgnoreCase(st) || "Disetujui".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-success status-badge"><i class="fa-solid fa-check-circle me-1"></i> Aktif</span>
                                    <% } else if ("Dibatalkan".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-danger status-badge"><i class="fa-solid fa-ban me-1"></i> Dibatalkan</span>
                                    <% } else if ("Ditolak".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-secondary status-badge"><i class="fa-solid fa-xmark me-1"></i> Ditolak</span>
                                    <% } else { %>
                                        <span class="badge bg-light text-dark border status-badge"><%= st %></span>
                                    <% } %>
                                </td>

                                <td class="text-center">
                                    <% if ("Booked".equalsIgnoreCase(st) || "Pending".equalsIgnoreCase(st)) { %>
                                        <a href="prosesBooking?action=batal&id=<%= t.getIdTransaksi() %>&idKamar=<%= t.getKamar().getIdKamar() %>" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Yakin ingin membatalkan booking ini?')">
                                            <i class="fa-solid fa-xmark me-1"></i> Batal
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-sm btn-light text-muted border" disabled>
                                            <i class="fa-solid fa-lock"></i>
                                        </button>
                                    <% } %>
                                </td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>