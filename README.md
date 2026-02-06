# SA:MP Anti-Cheat System

Sistem anti-cheat ringan sisi server untuk SA:MP yang ditulis dalam Pawn. Mendeteksi metode cheat umum melalui analisis perilaku dan validasi data klien.

## Fitur
- Deteksi speed hack (validasi pergerakan kaki)
- Deteksi teleport hack (lompatan posisi abnormal)
- Deteksi fly hack dan underground hack (validasi sumbu Z)
- Deteksi hack kesehatan dan armor (batas nilai)
- Deteksi hack senjata (ID tidak valid dan amunisi berlebihan)
- Sistem penendaan kick untuk memastikan pesan peringatan sampai ke pemain
- Penanganan pengecualian teleport admin
- Pengecualian aksi khusus (jetpack, parasut, menunduk)

## Instalasi
1. Simpan skrip sebagai `anticheat.pwn`
2. Sertakan dalam gamemode Anda atau kompilasi sebagai filterscript:
```pawn
#include <anticheat>
```
3. Sesuaikan ambang deteksi di bagian define jika diperlukan:
   - `MAX_SPEED`: Kecepatan maksimum berjalan/lari yang diizinkan (m/s)
   - `MAX_TP_DIST`: Jarak teleport maksimum yang diizinkan (meter)
   - `MAX_HP` / `MAX_ARMOR`: Batas kesehatan dan armor
   - `MAX_AMMO`: Batas amunisi global per senjata
   - `DELAY_KICK`: Penundaan pesan sebelum menendang (milidetik)

## Cara Kerja
- Menjalankan pemeriksaan setiap 800ms per pemain setelah spawn
- Membandingkan posisi saat ini dengan posisi sebelumnya untuk menghitung kecepatan pergerakan
- Memvalidasi nilai kesehatan/armor terhadap batas yang wajar
- Memindai semua slot senjata untuk ID tidak valid dan jumlah amunisi abnormal
- Memeriksa koordinat Z untuk anomali terbang/bawah tanah
- Mengirim pesan peringatan sebelum menendang dengan penundaan 300ms untuk memastikan pengiriman
- Melewati pemeriksaan untuk admin selama perintah teleport yang sah
- Mengabaikan aksi khusus seperti jetpack dan parasut selama deteksi terbang

## Keterbatasan
- Bukan solusi anti-cheat lengkap, dirancang sebagai lapisan perlindungan dasar
- Dapat menghasilkan positif palsu dalam kasus langka (ledakan, bug)
- Tidak dapat mendeteksi cheat visual (hack radar, hack dinding)
- Membutuhkan validasi sisi server untuk mekanika game kritis
- Harus dikombinasikan dengan langkah keamanan lain untuk server produksi

## Catatan
Skrip ini menyediakan deteksi cheat dasar. Untuk perlindungan yang kuat, gabungkan dengan plugin anti-cheat khusus (SAC, DACE) dan terapkan validasi sisi server tambahan untuk mekanika game. Selalu uji ambang batas pada server spesifik Anda untuk meminimalkan positif palsu.ction. For robust protection, combine with dedicated anti-cheat plugins (SAC, DACE) and implement additional server-side validations for game mechanics. Always test thresholds on your specific server to minimize false positives.
