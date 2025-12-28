<%-- 
    Document   : login
    Created on : 13 Dec 2025
    Author     : andin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk | E-Kos</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-color: #0d2c56;
            --accent-color: #fca311;
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
        .card-login {
            border: none;
            border-top: 5px solid var(--primary-color);
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            width: 100%;
            max-width: 400px;
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
        .form-floating label { color: #999; }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 text-center mb-4">
                <h2 class="fw-bold text-primary-custom"><i class="fa-solid fa-building me-2"></i>E-Kos</h2>
            </div>
            
            <div class="col-12 d-flex justify-content-center">
                <div class="card card-login bg-white">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <h4 class="fw-bold text-dark">Selamat Datang</h4>
                            <p class="text-muted small">Silakan masuk untuk melanjutkan</p>
                        </div>
                        
                        <% 
                            String status = request.getParameter("status");
                            if ("failed".equals(status)) {
                        %>
                            <div class="alert alert-danger text-center py-2 text-small shadow-sm" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-1"></i> Email atau Password salah!
                            </div>
                        <% 
                            } else if ("success".equals(status)) {
                        %>
                            <div class="alert alert-success text-center py-2 text-small shadow-sm" role="alert">
                                <i class="fa-solid fa-check-circle me-1"></i> Registrasi Berhasil!
                            </div>
                        <% 
                            } else if ("logout".equals(status)) {
                        %>
                            <div class="alert alert-info text-center py-2 text-small shadow-sm" role="alert">
                                <i class="fa-solid fa-info-circle me-1"></i> Anda telah logout.
                            </div>
                        <% } %>

                        <form action="login" method="POST">
                            
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                                <label for="email">Email</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                <label for="password">Password</label>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-custom shadow-sm">
                                    Masuk Aplikasi
                                </button>
                            </div>

                        </form>
                    </div>
                    
                    <div class="card-footer text-center py-3 bg-light border-0">
                        <span class="text-muted small">Belum punya akun?</span> 
                        <a href="register.jsp" class="text-decoration-none fw-bold text-primary-custom">Daftar disini</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>