/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Fachrul Rozi
 */
public class KamarReguler extends Kamar {
    private String ukuran;
    private String jenisKasur;

    public KamarReguler() {
        super();
    }

    @Override
    public String getTipeSpesifik() {
        return "Reguler";
    }
    // CONTOH LOGIKA: Diskon 5% jika sewa lebih dari 3 bulan
    public double hitungDiskon(int durasi) {
        if (durasi >= 3) {
            // Diskon 5% dari total harga dasar
            return getHargaBulanan() * durasi * 0.05; 
        }
        return 0;
    }
    public String getUkuran() { return ukuran; }
    public void setUkuran(String ukuran) { this.ukuran = ukuran; }

    public String getJenisKasur() { return jenisKasur; }
    public void setJenisKasur(String jenisKasur) { this.jenisKasur = jenisKasur; }
}