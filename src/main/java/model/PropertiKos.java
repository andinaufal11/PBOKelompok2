/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class PropertiKos {
    private int idKos;
    private int idPemilik; // Foreign Key reference
    private String namaKos;
    private String alamatKos;
    private String peraturan;

    public PropertiKos() {}

    // Constructor dengan parameter (Opsional, untuk memudahkan nanti)
    public PropertiKos(int idKos, int idPemilik, String namaKos, String alamatKos, String peraturan) {
        this.idKos = idKos;
        this.idPemilik = idPemilik;
        this.namaKos = namaKos;
        this.alamatKos = alamatKos;
        this.peraturan = peraturan;
    }

    // Getter & Setter
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
}
