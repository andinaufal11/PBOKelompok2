<%-- 
    Document   : laporan-pemilik.jsp
    Function   : Menampilkan Laporan Keuangan & Arsip (Dengan Sidebar & Notifikasi)
--%>

<%@page import="model.Penyewa"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.TransaksiDAO"%>
<%@page import="model.TransaksiSewa"%>
<%@page import="model.Pengguna"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. CEK LOGIN
    Pengguna user = (Pengguna) session.getAttribute("user");
    if (user == null || !"PEMILIK".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    int idOwner = user.getIdPengguna();
    TransaksiDAO dao = new TransaksiDAO();
    
    // 2. AMBIL DATA LAPORAN & STATISTIK
    List<TransaksiSewa> listLaporan = dao.getAllLaporan(idOwner);
    double totalPenghasilan = dao.getTotalPenghasilan(idOwner);
    int kamarTerisi = dao.getJumlahTerisi(idOwner);
    int totalKamar = dao.getTotalKamar(idOwner);

    // 3. AMBIL NOTIFIKASI UNTUK SIDEBAR
    List<TransaksiSewa> listRequest = dao.getPermintaanSewa(idOwner);
    if (listRequest == null) listRequest = new ArrayList<>();

    // 4. FORMATTER
    Locale localeID = new Locale("in", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy", localeID);
    String statusParam = request.getParameter("status");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Laporan Keuangan | Mitra E-Kos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style> 
        :root { --primary-color: #0d2c56; --accent-color: #fca311; }
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }
        
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
        
        /* CSS KHUSUS PRINT: Sembunyikan Sidebar & Navbar saat nge-print */
        @media print { 
            .no-print, .sidebar, .navbar { display: none !important; } 
            .col-md-9, .col-lg-10 { width: 100% !important; margin: 0 !important; padding: 0 !important; flex: 0 0 100%; max-width: 100%; }
            body { background-color: white !important; }
            .card { border: 1px solid #000 !important; box-shadow: none !important; }
            .badge { border: 1px solid #000; color: #000 !important; background: none !important; }
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top shadow-sm no-print">
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
                        
                        <a href="konfirmasi.jsp" class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fa-solid fa-inbox me-2"></i> Permintaan Sewa</span>
                            <% if (listRequest.size() > 0) { %>
                                <span class="badge bg-danger rounded-pill"><%= listRequest.size() %></span>
                            <% } %>
                        </a>
                        
                        <a href="data-penghuni.jsp" class="list-group-item">
                            <i class="fa-solid fa-users me-2"></i> Data Penghuni
                        </a>
                        
                        <a href="laporan-pemilik.jsp" class="list-group-item active">
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
                
                <%-- NOTIFIKASI --%>
                <% if ("cancelled".equals(statusParam)) { %>
                <div class="alert alert-success alert-dismissible fade show shadow-sm no-print" role="alert">
                    <i class="fa-solid fa-check-circle me-2"></i> Berhasil membatalkan sewa. Data diperbarui.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } else if ("error".equals(statusParam)) { %>
                <div class="alert alert-danger alert-dismissible fade show shadow-sm no-print" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> Gagal melakukan aksi.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                
                <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">Laporan & Arsip</h3>
                        <p class="text-muted mb-0">Ringkasan keuangan dan riwayat transaksi sewa.</p>
                    </div>
                    <button onclick="window.print()" class="btn btn-warning fw-bold shadow-sm">
                        <i class="fa-solid fa-print me-2"></i> Cetak PDF
                    </button>
                </div>
                
                <div class="d-none d-print-block text-center mb-4">
                    <h2>LAPORAN KEUANGAN E-KOS</h2>
                    <p>Periode Cetak: <%= sdf.format(new Date()) %></p>
                    <hr>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="card bg-success text-white shadow-sm h-100 border-0">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="opacity-75 text-uppercase small mb-1">Total Pendapatan</h6>
                                        <h3 class="fw-bold mb-0"><%= formatRupiah.format(totalPenghasilan) %></h3>
                                    </div>
                                    <i class="fa-solid fa-money-bill-wave fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white shadow-sm h-100 border-0" style="background-color: var(--primary-color);">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="opacity-75 text-uppercase small mb-1">Okupansi</h6>
                                        <h3 class="fw-bold mb-0"><%= kamarTerisi %> / <%= totalKamar %> Unit</h3>
                                    </div>
                                    <i class="fa-solid fa-door-open fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-secondary text-white shadow-sm h-100 border-0">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="opacity-75 text-uppercase small mb-1">Total Transaksi</h6>
                                        <h3 class="fw-bold mb-0"><%= listLaporan.size() %> Arsip</h3>
                                    </div>
                                    <i class="fa-solid fa-database fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                    <div class="card-header bg-white py-3 border-bottom d-flex align-items-center">
                        <i class="fa-solid fa-table-list me-2 text-secondary"></i> 
                        <h6 class="mb-0 fw-bold text-dark">Rincian Transaksi Sewa</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover mb-0 align-middle">
                                <thead style="background-color: var(--primary-color); color: white;">
                                    <tr>
                                        <th class="py-3 ps-4">No</th>
                                        <th>Tanggal</th>
                                        <th>Penyewa</th>
                                        <th>Kamar</th>
                                        <th>Durasi</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th class="text-center no-print">Opsi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listLaporan.isEmpty()) { %>
                                        <tr><td colspan="8" class="text-center py-5 text-muted">Belum ada data transaksi.</td></tr>
                                    <% } else {
                                        int no = 1;
                                        for (TransaksiSewa t : listLaporan) {
                                            String st = t.getStatusPembayaran();
                                            Penyewa p = (Penyewa) t.getPenyewa();
                                    %>
                                    <tr>
                                        <td class="ps-4 fw-bold text-secondary"><%= no++ %></td>
                                        <td><%= t.getTanggalMulai() %></td>
                                        
                                        <td>
                                            <div class="fw-bold text-dark"><%= p.getNamaPanggilan() %></div>
                                            <small class="text-muted"><%= (p.getNoHp() != null) ? p.getNoHp() : "-" %></small>
                                        </td>
                                        
                                        <td><span class="badge bg-light text-dark border">No. <%= t.getKamar().getNomorKamar() %></span></td>
                                        <td><%= t.getDurasiSewa() %> Bln</td>
                                        <td class="fw-bold text-success"><%= formatRupiah.format(t.getTotalBayar()) %></td>
                                        
                                        <td>
                                            <span class="badge bg-light text-dark border"><%= st %></span>
                                        </td>
                                        
                                        <td class="text-center no-print">
                                            <% if ("Disetujui".equalsIgnoreCase(st) || "Aktif".equalsIgnoreCase(st)) { %>
                                                 <a href="prosesBooking?action=batal&id=<%= t.getIdTransaksi() %>&idKamar=<%= t.getKamar().getIdKamar() %>&source=owner"
                                                    class="btn btn-sm btn-outline-danger" title="Batalkan Sewa"
                                                    onclick="return confirm('PERINGATAN: Membatalkan sewa akan mengubah status kamar menjadi KOSONG. Lanjutkan?')">
                                                     <i class="fa-solid fa-ban"></i>
                                                 </a>
                                            <% } else { %> 
                                                <span class="text-muted small">-</span> 
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% }} %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="d-none d-print-block mt-5 text-end">
                    <p>Jakarta, <%= sdf.format(new Date()) %></p>
                    <br><br><br>
                    <p class="fw-bold text-decoration-underline">( <%= user.getNamaPanggilan() %> )</p>
                    <p>Pemilik Kos</p>
                </div>

            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>