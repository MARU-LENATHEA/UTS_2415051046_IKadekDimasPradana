# EventHub Bali - UTS Pemrograman Mobile

EventHub adalah aplikasi mobile untuk mengeksplorasi katalog festival/konser publik dan mencatat agenda kehadiran personal. Aplikasi ini dibangun untuk memenuhi spesifikasi Project UTS Pemrograman Mobile.

## 👨‍💻 Identitas Pengembang
* **Nama:** I Kadek Dimas Pradana
* **NIM:** 2415051046
* **Kelas:** 4A / Pendidikan Teknik Informatika

## 🚀 Fitur Utama
* **Katalog Event (Explore):** Menampilkan daftar event dari REST API dengan *responsive grid/list layout*.
* **Detail Event & Passing Data:** Menampilkan rincian acara secara lengkap.
* **Manajemen Agenda (CRUD):** 
  * *Create:* Menyimpan event ke database lokal dengan form catatan & validasi.
  * *Read:* Melihat daftar event yang tersimpan.
  * *Update:* Memperbarui status kehadiran, prioritas, dan catatan personal.
  * *Delete:* Menghapus agenda dengan dialog konfirmasi.
* **State Management:** Menggunakan arsitektur `Provider` untuk mengelola *Loading*, *Data*, dan *Error State*.

## 🛠 Tech Stack & Arsitektur
* **Framework:** Flutter (Dart)
* **Arsitektur:** Clean Layered Architecture (`UI -> Provider -> Repository -> Service`)
* **State Management:** `provider` + `ChangeNotifier`
* **REST API:** Custom/MockAPI JSON (Fallback Mock Data terintegrasi)
* **Backend Database:** Supabase PostgreSQL

## 📸 Cara Menjalankan Project
1. Clone repositori ini: `git clone https://github.com/MARU-LENATHEA/UTS_2415051046_IKadekDimasPradana.git`
2. Masuk ke direktori: `cd UTS_2415051046_IKadekDimasPradana`
3. Unduh dependensi: `flutter pub get`
4. Jalankan aplikasi: `flutter run`