# 🏝️ Immich SBC Optimizer & Auto-Update Toolkit

> **Toolkit Pembaruan & Instalasi Immich Modern yang Dioptimalkan Khusus untuk Low-End SBC (ODROID-C2 / Amlogic S905 / 2GB RAM / DietPi & Debian ARM64).**

[![Architecture: ARM64](https://img.shields.io/badge/Arch-ARM64%20(Amlogic%20S905)-cyan.svg)](https://github.com/faisalfa123/immich-odroid-c2)
[![Platform: DietPi](https://img.shields.io/badge/OS-DietPi%20|%20Debian%20|%20Ubuntu-emerald.svg)](https://dietpi.com)
[![Integrasi: Bumiayu TUI](https://img.shields.io/badge/Integrated-Bumiayu%20TUI-purple.svg)](https://github.com/faisalfa123/bumiayu-de)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![RAM Footprint: ~450MB](https://img.shields.io/badge/RAM%20Footprint-~450MB%20(No%20OOM)-success.svg)](https://github.com/faisalfa123/immich-odroid-c2)

```
  ___                 _      _       ___ ___   ____ 
 |_ _|_ __  _ __ ___ (_) ___| |__   / __| _ ) / ___|
  | || '_ \| '_ ` _ \| |/ __| '_ \  \__ \ _ \ | |    
  | || | | | | | | | | | (__| | | | |___/___/ | |___ 
 |___|_| |_|_| |_| |_|_|\___|_| |_|          \____|
```

---

## 📌 Latar Belakang & Masalah di Odroid-C2 (RAM 2GB)

**Immich** adalah alternatif Google Photos terbaik saat ini, namun secara default sangat rakus sumber daya (membutuhkan RAM minimal 4GB–6GB jika Machine Learning / CLIP aktif). 

Pada SBC mini seperti **ODROID-C2 (Amlogic S905 Quad-Core ARM Cortex-A53 dengan RAM 2GB)**:
1. **OOM Kernel Freeze**: Menjalankan container Machine Learning standar Immich akan langsung menghabiskan RAM > 1.5GB, menyebabkan kernel Linux mengalami *Out-Of-Memory (OOM) Panic* dan server mati total/freeze.
2. **Thermal Throttling**: Transcoding video x264/x265 simultan di 4-core A53 tanpa pembatasan thread membuat suhu CPU melonjak hingga 80°C+.
3. **Database Corruption saat Update**: Pembaruan manual atau update container yang salah sering merusak skema PostgreSQL lama dan menghapus relasi foto.

**Toolkit ini hadir sebagai solusi cerdas:** Menghadirkan seluruh fungsi modern Immich dengan proteksi memori, zero data loss, suspensi proses otomatis, dan integrasi TUI ramah SSH.

---

## ✨ Fitur-Fitur Utama

| Fitur | Deskripsi |
|---|---|
| 🔄 **Auto-Detect Cerdas** | Otomatis mendeteksi apakah sistem memerlukan **Fresh Install** atau **Update**, serta mendeteksi stack yang ada (**Docker Compose** vs **DietPi Native ID 215**). |
| 🛡️ **Zero Data Loss & Safe DB** | Melakukan update ke versi modern tanpa menghapus volume foto maupun skema database PostgreSQL yang sudah berjalan. |
| 💾 **Auto-Backup & Rollback 1-Klik** | Otomatis mengekspor cadangan database (`pg_dumpall` / `pg_dump`) dan konfigurasi `.env` ke `/var/backups/immich/` sebelum update. Tersedia tombol Rollback instan jika terjadi kegagalan. |
| ⚡ **Low-End SBC Memory Guard** | Machine Learning (CLIP / Facial recognition) dinonaktifkan secara default, PostgreSQL buffer dibatasi ke 128MB, dan concurrency antrean dibatasi ke 1 agar server tetap dingin & stabil. |
| 📸 **Dukungan Format Lengkap** | Mendukung `.heic`, `.heif` (Apple iOS), Camera RAW (`.raw`, `.cr2`, `.nef`, `.dng`, `.arw`), serta video `x265/HEVC` (`.mp4`, `.mkv`) dan Apple QuickTime `.mov`. |
| ⏸️ **Process Guardian (Freeze & Thaw)** | Otomatis mematikan sementara layanan berat (Jellyfin, Plex, Nextcloud, qBittorrent, MariaDB) sebelum proses kompilasi/update, dan menyalakannya kembali saat selesai via signal trap `EXIT/TERM/INT` (baik sukses maupun gagal). |
| 🖥️ **TUI Interaktif & Bumiayu TUI Hook** | Menu visual berbasis terminal (`whiptail`/`dialog`) dan hook otomatis ke ruang kerja Toko Aplikasi [Bumiayu TUI](https://github.com/faisalfa123/bumiayu-de). |
| 📋 **Log Debugging Terperinci** | Seluruh jejak audit dan log eksekusi dicatat langsung di `/var/log/immich-updater.log`. |

---

## 🚀 Panduan Instalasi Cepat (1-Baris)

Jalankan perintah berikut di terminal **ODROID-C2** (DietPi / Debian ARM64 / Ubuntu Server):

```bash
curl -fsSL https://raw.githubusercontent.com/faisalfa123/immich-odroid-c2/main/install.sh | sudo bash
```

Setelah instalasi selesai, buka antarmuka toolkit kapan saja dengan mengetik:

```bash
sudo immich-sbc-tool
```

---

## 🎮 Tampilan Menu TUI

```
==========================================================
 🏝️ IMMICH SBC OPTIMIZER & UPDATER (ODROID-C2)
 Status Sistem: Terpasang (docker)
==========================================================
1) Auto-Detect & Upgrade Immich (Modern + Low-RAM Profile)
2) Fresh Install Immich (Optimized for Odroid-C2)
3) Backup Database & Konfigurasi Sekarang
4) Restore / Rollback ke Backup Terakhir
5) Cek Dukungan Format (HEIC, RAW, x265, MOV)
6) Lihat Live Debug Log (/var/log/immich-updater.log)
0) Keluar
==========================================================
```

---

## 💻 Penggunaan Mode CLI (Otomatisasi Script)

Jika Anda ingin menjalankan perintah otomatis tanpa masuk ke menu visual:

```bash
# Melakukan pembaruan otomatis (Zero Data Loss)
sudo immich-sbc-tool --update

# Melakukan fresh install (Optimized profile)
sudo immich-sbc-tool --install

# Melakukan backup database & konfigurasi instan
sudo immich-sbc-tool --backup

# Mengembalikan sistem ke backup terakhir (Rollback)
sudo immich-sbc-tool --rollback

# Memeriksa ketersediaan codec & library HEIC/RAW/x265
sudo immich-sbc-tool --check-formats
```

---

## 📊 Perbandingan Penggunaan Resource di ODROID-C2

| Parameter | Immich Bawaan (Default Docker) | Immich SBC Tool (Dioptimalkan) |
|---|---|---|
| **RAM Usage** | 1.8 GB – 2.1 GB (*Sering OOM Freeze*) | **~420 MB – 550 MB** (*Sangat Stabil*) |
| **Machine Learning** | Aktif (Menghabiskan CPU & RAM) | Dinonaktifkan secara aman |
| **PostgreSQL Shared Buffers** | Default dinamis | Dibatasi ke **128 MB** |
| **Thumbnail Concurrency** | 3-5 thread paralel | **1 antrean sekuensial** |
| **Suhu CPU S905** | 75°C – 85°C | **48°C – 58°C** |

---

## 📁 Struktur Berkas Repositori

```
immich-odroid-c2/
├── README.md                          # Dokumentasi lengkap proyek
├── LICENSE                            # Lisensi MIT terbuka
├── install.sh                         # Skrip instalasi 1-baris otomatis
├── bin/
│   └── immich-sbc-tool                # Mesin TUI & CLI utama
├── config/
│   ├── docker-compose.low-ram.yml     # Compose stack teroptimasi Odroid-C2
│   ├── immich.env.template            # Template konfigurasi .env hemat memori
│   └── postgresql-sbc.conf            # Tuning memori PostgreSQL (Buffer 128MB)
├── hooks/
│   └── bumiayu-integration.sh         # Skrip integrasi ke Bumiayu TUI
└── tests/
    └── test-formats.sh                # Pengujian format HEIC/RAW/MOV/x265
```

---

## 🤝 Integrasi dengan Bumiayu TUI

Toolkit ini dirancang agar selaras dengan ekosistem [Bumiayu TUI (Desktop Environment TUI)](https://github.com/faisalfa123/bumiayu-de):
- Skrip integrasi di `hooks/bumiayu-integration.sh` otomatis mendaftarkan hook ke `/etc/bumiayu/hooks.d/immich.sh`.
- Pengguna dapat membuka dan mengelola Immich langsung dari Workspace 2 (*Toko Aplikasi Server*) pada antarmuka Bumiayu TUI.

---

## 📄 Lisensi

Proyek ini dirilis di bawah lisensi terbuka [MIT License](LICENSE). Bebas digunakan, dimodifikasi, dan didistribusikan untuk server pribadi maupun komunitas.
