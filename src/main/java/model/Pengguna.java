/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public abstract class Pengguna {
    // Atribut dasar sesuai tabel 'pengguna'
    protected int idPengguna;
    protected String namaPanggilan;
    protected String email;
    protected String password;
    protected String role; // 'PEMILIK' atau 'PENYEWA'

    // Constructor Kosong
    public Pengguna() {}

    // Constructor dengan Parameter
    public Pengguna(int idPengguna, String namaPanggilan, String email, String password, String role) {
        this.idPengguna = idPengguna;
        this.namaPanggilan = namaPanggilan;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // Abstract Method (Wajib di-override/diisi oleh anak kelasnya)
    // Sesuai Proposal: verifikasiIdentitas()
    public abstract void verifikasiIdentitas();

    // Getter & Setter (Encapsulation)
    public int getIdPengguna() { return idPengguna; }
    public void setIdPengguna(int idPengguna) { this.idPengguna = idPengguna; }

    public String getNamaPanggilan() { return namaPanggilan; }
    public void setNamaPanggilan(String namaPanggilan) { this.namaPanggilan = namaPanggilan; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
