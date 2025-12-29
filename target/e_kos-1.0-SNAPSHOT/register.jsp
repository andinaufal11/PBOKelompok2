<%-- 
    Document   : register
    Created on : 13 Dec 2025
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
        :root {
            --primary-color: #0d2c56; /* Navy Blue */
            --accent-color: #fca311;  /* Warm Gold */
            --bg-color: #f4f6f9;
        }
        body {
            background-color: var(--bg-color);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .card-register {
            border: none;
            border-top: 5px solid var(--primary-color);
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .text-primary-custom { color: var(--primary-color); }
        
        .btn-custom {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px;
            font-weight: 600;
            border-radius: 6px;
        }
        .btn-custom:hover { background-color: #082042; color: #fff; }
        
        /* Radio Button Custom Styling */
        .btn-check:checked + .btn-outline-custom {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        .btn-outline-custom {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .btn-outline-custom:hover {
            background-color: #eef2f7;
            color: var(--primary-color);
        }

        .form-floating label { color: #999; }
        #alamatContainer { transition: all 0.4s ease-in-out; }
    </style>
</head>
<body>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="text-center mb-4">
                    <h2 class="fw-bold text-primary-custom"><i class="fa-solid fa-building me-2"></i>E-Kos</h2>
                    <p class="text-muted">Platform Manajemen Kos Modern</p>
                </div>

                <div class="card card-register bg-white">
                    <div class="card-body p-4 p-md-5">
                        <h4 class="fw-bold text-center mb-4 text-dark">Buat Akun Baru</h4>
                        
                        <form action="register" method="POST" class="needs-validation" novalidate>
                            
                            <div class="mb-4">
                                <label class="form-label small text-uppercase fw-bold text-muted">Daftar Sebagai</label>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="role" id="rolePenyewa" value="PENYEWA" checked onclick="toggleForm()">
                                        <label class="btn btn-outline-custom w-100 py-2" for="rolePenyewa">
                                            <i class="fa-solid fa-user me-1"></i> Penyewa
                                        </label>
                                    </div>
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="role" id="rolePemilik" value="PEMILIK" onclick="toggleForm()">
                                        <label class="btn btn-outline-custom w-100 py-2" for="rolePemilik">
                                            <i class="fa-solid fa-key me-1"></i> Pemilik
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="nama" name="nama" placeholder="Nama Panggilan" required>
                                <label for="nama">Nama Panggilan</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                                <label for="email">Email Address</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                <label for="password">Password</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" id="noHp" name="noHp" placeholder="08123456789" required>
                                <label for="noHp">Nomor WhatsApp/HP</label>
                            </div>

                            <div id="alamatContainer" class="form-floating mb-3">
                                <textarea class="form-control" placeholder="Alamat Asal" id="alamat" name="alamat" style="height: 100px"></textarea>
                                <label for="alamat">Alamat Asal (Sesuai KTP)</label>
                                <div class="form-text text-muted small ms-1">*Wajib diisi untuk penyewa</div>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-custom btn-lg shadow-sm">
                                    Daftar Sekarang
                                </button>
                            </div>

                        </form>
                    </div>
                    
                    <div class="card-footer text-center py-3 bg-light border-0">
                        <span class="text-muted small">Sudah punya akun?</span> 
                        <a href="login.jsp" class="text-decoration-none fw-bold text-primary-custom">Masuk disini</a>
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
                alamatContainer.style.display = "block";
                inputAlamat.setAttribute("required", "required");
            } else {
                alamatContainer.style.display = "none";
                inputAlamat.removeAttribute("required");
                inputAlamat.value = "";
            }
        }
        window.onload = toggleForm;
    </script>

</body>
</html>