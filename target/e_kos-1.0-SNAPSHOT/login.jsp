<%-- 
    Document   : login
    Created on : 13 Dec 2025, 23.31.19
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
        body {
            /* Gradient Background yang sama dengan Register */
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card-login {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
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
        .form-floating label { color: #999; }
    </style>
</head>
<body>

    <div class="card card-login">
        
        <div class="card-header card-header-custom">
            <i class="fa-solid fa-right-to-bracket"></i>
            <h3 class="fw-bold text-dark">Selamat Datang</h3>
            <p class="text-muted small">Silakan masuk untuk melanjutkan</p>
        </div>

        <div class="card-body p-4">
            
            <% 
                String status = request.getParameter("status");
                if ("failed".equals(status)) {
            %>
                <div class="alert alert-danger text-center fade show" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-1"></i> Email atau Password salah!
                </div>
            <% 
                } else if ("success".equals(status)) {
            %>
                <div class="alert alert-success text-center fade show" role="alert">
                    <i class="fa-solid fa-check-circle me-1"></i> Registrasi Berhasil! Silakan Login.
                </div>
            <% 
                } else if ("logout".equals(status)) {
            %>
                <div class="alert alert-info text-center fade show" role="alert">
                    <i class="fa-solid fa-info-circle me-1"></i> Anda telah logout.
                </div>
            <% } %>

            <form action="login" method="POST">
                
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                    <label for="email"><i class="fa-regular fa-envelope me-2"></i>Email</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <label for="password"><i class="fa-solid fa-lock me-2"></i>Password</label>
                </div>

                <div class="d-grid mt-4">
                    <button type="submit" class="btn btn-custom btn-lg">
                        Masuk Aplikasi
                    </button>
                </div>

            </form>
        </div>
        
        <div class="card-footer text-center py-3 bg-light">
            <span class="text-muted">Belum punya akun?</span> 
            <a href="register.jsp" class="text-decoration-none fw-bold text-success">Daftar disini</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>