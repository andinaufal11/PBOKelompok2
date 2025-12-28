/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Penyewa extends Pengguna {
    // Atribut khusus Penyewa
    private String namaLengkap;
    private String alamatAsal;
    private String noHp;
    private String ktpPath;

    public Penyewa() {
        super(); // Memanggil constructor induk
        this.setRole("PENYEWA");
    }

    // Implementasi Method Abstract dari Parent
    @Override
    public void verifikasiIdentitas() {
        System.out.println("Verifikasi Penyewa: Cek validasi file KTP di " + this.ktpPath);
        // Nanti logika upload/cek file ada di sini atau di Controller
    }

    // Getter & Setter Khusus Penyewa
    public String getNamaLengkap() { return namaLengkap; }
    public void setNamaLengkap(String namaLengkap) { this.namaLengkap = namaLengkap; }

    public String getAlamatAsal() { return alamatAsal; }
    public void setAlamatAsal(String alamatAsal) { this.alamatAsal = alamatAsal; }

    public String getNoHp() { return noHp; }
    public void setNoHp(String noHp) { this.noHp = noHp; }

    public String getKtpPath() { return ktpPath; }
    public void setKtpPath(String ktpPath) { this.ktpPath = ktpPath; }
    
    
}