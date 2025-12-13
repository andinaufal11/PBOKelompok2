/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;

public class PemilikKos extends Pengguna {
    private String noHp;
    private String skPath; // Surat Kepemilikan
    
    // AGREGASI: Satu pemilik punya banyak properti (List)
    private List<PropertiKos> daftarProperti = new ArrayList<>();

    public PemilikKos() {
        super();
        this.setRole("PEMILIK");
    }

    @Override
    public void verifikasiIdentitas() {
        System.out.println("Verifikasi Pemilik: Cek validasi Surat Kepemilikan di " + this.skPath);
    }

    // Method untuk Agregasi (Menambah properti ke pemilik ini)
    public void tambahProperti(PropertiKos properti) {
        this.daftarProperti.add(properti);
    }

    public List<PropertiKos> getDaftarProperti() {
        return daftarProperti;
    }

    // Getter & Setter
    public String getNoHp() { return noHp; }
    public void setNoHp(String noHp) { this.noHp = noHp; }

    public String getSkPath() { return skPath; }
    public void setSkPath(String skPath) { this.skPath = skPath; }
}
