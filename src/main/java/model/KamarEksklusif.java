/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Fachrul Rozi
 */
public class KamarEksklusif extends Kamar {
    private String fasilitasTambahan;
    private String luasArea;

    public KamarEksklusif() {
        super();
    }
    // CONTOH LOGIKA: Biaya layanan (Service Charge) 10% dari total
    public double hitungBiayaLayanan(int durasi) {
        double total = getHargaBulanan() * durasi;
        return total * 0.10; // Tambahan biaya 10%
    }
    @Override
    public String getTipeSpesifik() {
        return "Eksklusif";
    }

    public String getFasilitasTambahan() { return fasilitasTambahan; }
    public void setFasilitasTambahan(String fasilitasTambahan) { this.fasilitasTambahan = fasilitasTambahan; }

    public String getLuasArea() { return luasArea; }
    public void setLuasArea(String luasArea) { this.luasArea = luasArea; }
}
