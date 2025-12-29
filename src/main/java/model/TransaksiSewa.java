/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

// Sesuai Diagram: Menghubungkan Penyewa dan Kamar
public class TransaksiSewa {
    private int idTransaksi;
    
    // Relasi Antar Kelas (Aggregation/Association)
    private Pengguna penyewa; // Merepresentasikan objek Penyewa
    private Kamar kamar;      // Merepresentasikan objek Kamar
    
    private String tanggalMulai;
    private int durasiSewa;   // Dalam bulan
    private double totalBayar;
    private String statusPembayaran; // 'Pending', 'Lunas', 'Batal'

    public TransaksiSewa() {}

    // Getter & Setter
    public int getIdTransaksi() { return idTransaksi; }
    public void setIdTransaksi(int idTransaksi) { this.idTransaksi = idTransaksi; }

    public Pengguna getPenyewa() { return penyewa; }
    public void setPenyewa(Pengguna penyewa) { this.penyewa = penyewa; }

    public Kamar getKamar() { return kamar; }
    public void setKamar(Kamar kamar) { this.kamar = kamar; }

    public String getTanggalMulai() { return tanggalMulai; }
    public void setTanggalMulai(String tanggalMulai) { this.tanggalMulai = tanggalMulai; }

    public int getDurasiSewa() { return durasiSewa; }
    public void setDurasiSewa(int durasiSewa) { this.durasiSewa = durasiSewa; }

    public double getTotalBayar() { return totalBayar; }
    public void setTotalBayar(double totalBayar) { this.totalBayar = totalBayar; }

    public String getStatusPembayaran() { return statusPembayaran; }
    public void setStatusPembayaran(String statusPembayaran) { this.statusPembayaran = statusPembayaran; }
}