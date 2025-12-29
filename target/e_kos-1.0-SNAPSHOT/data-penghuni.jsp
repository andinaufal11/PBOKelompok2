<%-- 
    Document   : data-penghuni.jsp
    Function   : Menampilkan Daftar Penghuni Aktif secara Terpisah
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.TransaksiDAO"%>
<%@page import="model.TransaksiSewa"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. CEK SESSION LOGIN
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PEMILIK".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. AMBIL DATA PENGHUNI AKTIF & NOTIFIKASI
    TransaksiDAO transDao = new TransaksiDAO();
    List<TransaksiSewa> listPenghuni = transDao.getPenghuniAktif(user.getIdPengguna());
    
    // Ambil data notifikasi untuk sidebar (agar badge merah muncul)
    List<TransaksiSewa> listRequest = transDao.getPermintaanSewa(user.getIdPengguna());
    if (listRequest == null) listRequest = new ArrayList<>();

    String status = request.getParameter("status");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Penghuni | Mitra E-Kos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #0d2c56; /* Navy */
            --accent-color: #fca311;  /* Gold */
        }
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }
        
        /* Navbar Styling */
        .navbar-custom { background-color: var(--primary-color); }
        
        /* Sidebar Styling */
        .sidebar { min-height: 100vh; background-color: white; border-right: 1px solid #dee2e6; }
        .sidebar .list-group-item { border: none; color: #6c757d; padding: 12px 20px; font-weight: 500; transition: all 0.2s; }
        .sidebar .list-group-item:hover { background-color: #f8f9fa; color: var(--primary-color); transform: translateX(5px); }
        .sidebar .list-group-item.active { 
            background-color: #eef2f7; 
            color: var(--primary-color); 
            border-left: 4px solid var(--primary-color);
            border-radius: 0;
            font-weight: bold;
        }

        /* Table Styling */
        .table thead th {
            background-color: var(--primary-color);
            color: white;
            border: none;
            font-weight: 500;
            padding: 15px;
        }
        .table tbody td { padding: 15px; vertical-align: middle; }
        .badge-status { font-size: 0.85em; padding: 0.6em 1em; border-radius: 20px; }
        
        /* Button Gold */
        .btn-gold { background-color: var(--accent-color); color: #000; font-weight: bold; border: none; }
        .btn-gold:hover { background-color: #e0910f; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top shadow-sm">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-building-user me-2"></i>Mitra E-Kos</a>
            <div class="d-flex align-items-center text-white">
                <div class="text-end me-3 d-none d-md-block">
                    <small class="d-block text-white-50" style="font-size: 0.75rem;">Login sebagai</small>
                    <span class="fw-semibold"><%= user.getNamaPanggilan() %></span>
                </div>
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
                        
                        <a href="konfirmasi.jsp" class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fa-solid fa-inbox me-2"></i> Permintaan Sewa</span>
                            <% if (listRequest.size() > 0) { %>
                                <span class="badge bg-danger rounded-pill"><%= listRequest.size() %></span>
                            <% } %>
                        </a>
                        
                        <a href="data-penghuni.jsp" class="list-group-item active">
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
                
                <% if ("cancelled".equals(status)) { %>
                    <div class="alert alert-warning alert-dismissible fade show shadow-sm border-0" role="alert">
                        <div class="d-flex align-items-center">
                            <i class="fa-solid fa-user-slash fa-lg me-3 text-warning"></i>
                            <div>
                                <strong>Berhasil Dihentikan!</strong> Data penghuni telah dihapus dari daftar aktif.
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if ("error".equals(status)) { %>
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> Gagal memproses data. Silakan coba lagi.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">Penghuni Aktif</h3>
                        <p class="text-muted mb-0">Daftar penyewa yang sedang menempati kos Anda saat ini.</p>
                    </div>
                    <span class="badge bg-primary rounded-pill px-3 py-2 fs-6 shadow-sm">
                        <i class="fa-solid fa-users me-1"></i> <%= listPenghuni.size() %> Orang
                    </span>
                </div>
                
                <div class="card shadow border-0 bg-white overflow-hidden rounded-3">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Kamar</th>
                                        <th>Nama Penghuni</th>
                                        <th>Kontak</th>
                                        <th>Mulai Sewa</th>
                                        <th>Durasi</th>
                                        <th>Status</th>
                                        <th class="text-center">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listPenghuni.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <div class="opacity-25 mb-3"><i class="fa-solid fa-users-slash fa-4x text-secondary"></i></div>
                                                <h5 class="text-muted">Tidak ada penghuni aktif.</h5>
                                                <p class="text-secondary small">Belum ada kamar yang terisi saat ini.</p>
                                            </td>
                                        </tr>
                                    <% } else { 
                                        for (TransaksiSewa t : listPenghuni) { 
                                            model.Penyewa p = (model.Penyewa) t.getPenyewa();
                                    %>
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <div class="bg-light rounded p-2 me-2 border text-center" style="width: 45px;">
                                                    <i class="fa-solid fa-bed text-secondary"></i>
                                                </div>
                                                <span class="fw-bold text-dark">No. <%= t.getKamar().getNomorKamar() %></span>
                                            </div>
                                        </td>
                                        
                                        <td>
                                            <div class="fw-bold text-dark"><%= p.getNamaPanggilan() %></div>
                                            <small class="text-muted"><i class="fa-regular fa-envelope me-1"></i><%= p.getEmail() %></small>
                                        </td>
                                        
                                        <td>
                                            <% if (p.getNoHp() != null && !p.getNoHp().equals("-")) { %>
                                                <a href="https://wa.me/<%= p.getNoHp().replaceFirst("^0", "62") %>" target="_blank" class="btn btn-sm btn-success rounded-pill px-3 shadow-sm fw-bold">
                                                    <i class="fa-brands fa-whatsapp me-1"></i> Chat
                                                </a>
                                            <% } else { %>
                                                <span class="text-muted small italic">- Tidak ada -</span>
                                            <% } %>
                                        </td>

                                        <td class="text-secondary"><%= t.getTanggalMulai() %></td>
                                        <td><span class="badge bg-light text-dark border"><%= t.getDurasiSewa() %> Bulan</span></td>
                                        
                                        <td>
                                            <% String st = t.getStatusPembayaran(); %>
                                            <% if("Disetujui".equalsIgnoreCase(st) || "Aktif".equalsIgnoreCase(st)) { %>
                                                <span class="badge bg-success bg-opacity-10 text-success badge-status">
                                                    <i class="fa-solid fa-circle-check me-1"></i> Aktif
                                                </span>
                                            <% } else { %>
                                                <span class="badge bg-secondary badge-status"><%= st %></span>
                                            <% } %>
                                        </td>
                                        
                                        <td class="text-center">
                                            <a href="prosesBooking?action=batal&id=<%= t.getIdTransaksi() %>&idKamar=<%= t.getKamar().getIdKamar() %>&source=penghuni" 
                                               class="btn btn-sm btn-outline-danger fw-bold px-3"
                                               onclick="return confirm('PERINGATAN: Apakah Anda yakin ingin menghentikan sewa ini? Status kamar akan berubah menjadi KOSONG.')">
                                                <i class="fa-solid fa-user-xmark me-1"></i> Stop Sewa
                                            </a>
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