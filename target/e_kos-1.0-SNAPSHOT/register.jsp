<%-- 
    Document   : register
    Created on : 13 Dec 2025, 23.29.12
    Author     : andin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akun | E-Kos</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            /* Gradient Background yang Fresh (Hijau Tosca ke Biru) */
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .card-register {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .card-header-custom {
            background-color: #fff;
            border-bottom: none;
            padding-top: 30px;
            text-align: center;
        }
        
        .card-header-custom i {
            color: #11998e;
            font-size: 3rem;
            margin-bottom: 10px;
        }
        
        .btn-custom {
            background: linear-gradient(to right, #11998e, #38ef7d);
            border: none;
            color: white;
            padding: 12px;
            font-weight: bold;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(56, 239, 125, 0.4);
        }

        .form-floating label {
            color: #999;
        }

        .form-check-input:checked {
            background-color: #11998e;
            border-color: #11998e;
        }
        
        /* Animasi halus untuk kolom alamat */
        #alamatContainer {
            transition: all 0.5s ease-in-out;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card card-register">
                    
                    <div class="card-header card-header-custom">
                        <i class="fa-solid fa-house-chimney-user"></i>
                        <h3 class="fw-bold text-dark">Daftar E-Kos</h3>
                        <p class="text-muted small">Kelola atau cari kos impianmu sekarang</p>
                    </div>

                    <div class="card-body p-4">
                        <form action="register" method="POST" class="needs-validation" novalidate>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary">Saya ingin mendaftar sebagai:</label>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="role" id="rolePenyewa" value="PENYEWA" checked onclick="toggleForm()">
                                        <label class="btn btn-outline-success w-100" for="rolePenyewa">
                                            <i class="fa-solid fa-user me-1"></i> Penyewa
                                        </label>
                                    </div>
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="role" id="rolePemilik" value="PEMILIK" onclick="toggleForm()">
                                        <label class="btn btn-outline-primary w-100" for="rolePemilik">
                                            <i class="fa-solid fa-key me-1"></i> Pemilik Kos
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="nama" name="nama" placeholder="Nama Panggilan" required>
                                <label for="nama"><i class="fa-regular fa-id-card me-2"></i>Nama Panggilan</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                                <label for="email"><i class="fa-regular fa-envelope me-2"></i>Email Address</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                <label for="password"><i class="fa-solid fa-lock me-2"></i>Password</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="noHp" name="noHp" placeholder="08123456789" required>
                                <label for="noHp"><i class="fa-solid fa-phone me-2"></i>Nomor WhatsApp/HP</label>
                            </div>

                            <div id="alamatContainer" class="form-floating mb-3">
                                <textarea class="form-control" placeholder="Alamat Asal" id="alamat" name="alamat" style="height: 100px"></textarea>
                                <label for="alamat"><i class="fa-solid fa-map-location-dot me-2"></i>Alamat Asal (Sesuai KTP)</label>
                                <div class="form-text text-muted small ms-1">*Wajib diisi untuk penyewa</div>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-custom btn-lg">
                                    Daftar Sekarang <i class="fa-solid fa-arrow-right ms-2"></i>
                                </button>
                            </div>

                        </form>
                    </div>
                    
                    <div class="card-footer text-center py-3 bg-light">
                        <span class="text-muted">Sudah punya akun?</span> 
                        <a href="login.jsp" class="text-decoration-none fw-bold text-success">Masuk disini</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function toggleForm() {
            var isPenyewa = document.getElementById("rolePenyewa").checked;
            var alamatContainer = document.getElementById("alamatContainer");
            var inputAlamat = document.getElementById("alamat");

            if (isPenyewa) {
                // Tampilkan kolom alamat
                alamatContainer.style.display = "block";
                inputAlamat.setAttribute("required", "required"); // Tambah validasi HTML5
            } else {
                // Sembunyikan kolom alamat (karena Pemilik Kos set properti nanti)
                alamatContainer.style.display = "none";
                inputAlamat.removeAttribute("required"); // Hapus validasi agar bisa submit
                inputAlamat.value = ""; // Bersihkan nilai
            }
        }
        
        // Jalankan sekali saat load agar status awal benar
        window.onload = toggleForm;
    </script>

</body>
</html>
