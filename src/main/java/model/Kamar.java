/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Fachrul Rozi
 */

public class Kamar {
    protected int idKamar;
    protected int idKos;
    protected String nomorKamar;
    protected double hargaBulanan;
    protected String fasilitas;
    protected String statusKamar;
    
    // Variabel untuk menyimpan nama file foto kamar
    protected String fotoKamar; 

    // BARU: Tambahan agar bisa dipanggil di riwayat sewa (t.getKamar().getNamaKos())
    protected String namaKos; 

    public Kamar() {}

    // Getter Setter
    public int getIdKamar() { return idKamar; }
    public void setIdKamar(int idKamar) { this.idKamar = idKamar; }
    
    public int getIdKos() { return idKos; }
    public void setIdKos(int idKos) { this.idKos = idKos; }
    
    public String getNomorKamar() { return nomorKamar; }
    public void setNomorKamar(String nomorKamar) { this.nomorKamar = nomorKamar; }
    
    public double getHargaBulanan() { return hargaBulanan; }
    public void setHargaBulanan(double hargaBulanan) { this.hargaBulanan = hargaBulanan; }
    
    public String getFasilitas() { return fasilitas; }
    public void setFasilitas(String fasilitas) { this.fasilitas = fasilitas; }
    
    public String getStatusKamar() { return statusKamar; }
    public void setStatusKamar(String statusKamar) { this.statusKamar = statusKamar; }
    
    public String getFotoKamar() { return fotoKamar; }
    public void setFotoKamar(String fotoKamar) { this.fotoKamar = fotoKamar; }
    
    // BARU: Getter & Setter Nama Kos
    public String getNamaKos() { return namaKos; }
    public void setNamaKos(String namaKos) { this.namaKos = namaKos; }

    // Metode Polimorfisme
    public String getTipeSpesifik() {
        return "Umum";
    }
}