/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class PropertiKos {
    private int idKos;
    private int idPemilik;
    private String namaKos;
    private String alamatKos;
    private String peraturan;
    private String fotoKos;
    
    // TAMBAHAN: Variabel untuk menampung jumlah kamar
    private int jumlahKamar;

    // --- GETTER & SETTER ---
    
    public int getIdKos() { return idKos; }
    public void setIdKos(int idKos) { this.idKos = idKos; }

    public int getIdPemilik() { return idPemilik; }
    public void setIdPemilik(int idPemilik) { this.idPemilik = idPemilik; }

    public String getNamaKos() { return namaKos; }
    public void setNamaKos(String namaKos) { this.namaKos = namaKos; }

    public String getAlamatKos() { return alamatKos; }
    public void setAlamatKos(String alamatKos) { this.alamatKos = alamatKos; }

    public String getPeraturan() { return peraturan; }
    public void setPeraturan(String peraturan) { this.peraturan = peraturan; }

    public String getFotoKos() { return fotoKos; }
    public void setFotoKos(String fotoKos) { this.fotoKos = fotoKos; }

    // TAMBAHAN: Getter & Setter untuk jumlahKamar
    public int getJumlahKamar() { return jumlahKamar; }
    public void setJumlahKamar(int jumlahKamar) { this.jumlahKamar = jumlahKamar; }
}