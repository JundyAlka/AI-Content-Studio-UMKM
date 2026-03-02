# 🤖 AI Content Studio UMKM

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/Riverpod-774976?style=for-the-badge&logo=riverpod&logoColor=white)](https://riverpod.dev)
[![AI](https://img.shields.io/badge/Powered%20By-Gemini%20%26%20Stability-orange?style=for-the-badge)](https://deepmind.google/technologies/gemini/)

**AI Content Studio UMKM** adalah asisten cerdas berbasis AI yang dirancang khusus untuk pelaku UMKM di Indonesia. Aplikasi ini membantu mengotomatisasi pembuatan konten kreatif, mulai dari caption media sosial hingga visual produk yang memukau.

---

## 📸 Screenshots

| Dashboard Utama | AI Caption Generator |
| :---: | :---: |
| ![Dashboard](https://via.placeholder.com/300x600?text=Dashboard+UMKM) | ![AI Tools](https://via.placeholder.com/300x600?text=AI+Caption+Tools) |

| AI Image Generator | Content Library |
| :---: | :---: |
| ![AI Image](https://via.placeholder.com/300x600?text=AI+Image+Generator) | ![Library](https://via.placeholder.com/300x600?text=Content+Library) |

---

## ✨ Fitur Utama

- **🚀 Smart Onboarding**: Personalisasi konten berdasarkan jenis usaha, brand tone, dan target audiens.
- **✍️ AI Caption Generator**: Menghasilkan caption kreatif untuk Instagram, TikTok, dan Facebook dalam bahasa Indonesia yang natural.
- **🎨 AI Product Visualizer**: Membuat gambar produk profesional menggunakan integrasi **Stability AI**.
- **📅 Content Planner**: Kelola jadwal posting media sosial secara teratur.
- **📊 Business Analytics**: Pantau performa konten Anda langsung dari aplikasi.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Database & Auth**: [Firebase](https://firebase.google.com)
- **AI Integration**: 
  - Google Gemini (Text generation & Prompt refinement)
  - Stability AI (Image generation)
- **Animations**: [Flutter Animate](https://pub.dev/packages/flutter_animate)

---

## 🚀 Persiapan & Instalasi

### Prasyarat
- Flutter SDK (Latest Stable)
- Firebase Project

### Langkah Instalasi

1. **Clone Repository**
   ```bash
   git clone https://github.com/username/ai_content_studio_umkm.git
   cd ai_content_studio_umkm
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Environment (.env)**
   Aplikasi ini memerlukan API Key untuk layanan AI. Duplikat file `.env.example` menjadi `.env` dan masukkan API Key Anda:
   ```bash
   cp .env.example .env
   ```
   Isi file `.env`:
   ```env
   GEMINI_API_KEY=your_gemini_key
   STABILITY_API_KEY=your_stability_key
   ```

4. **Setup Firebase**
   - Tambahkan `google-services.json` (Android) atau `GoogleService-Info.plist` (iOS) ke folder yang sesuai.
   - Pastikan Firebase Auth dan Firestore sudah aktif.

5. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

---

## 📂 Struktur Folder
```text
lib/
├── config/         # Konfigurasi App & Env
├── features/       # Modul Fitur (Auth, AI, Dashboard)
├── models/         # Data Models
├── services/       # Integrasi API & Logic
├── theme/          # UI Design System
└── widgets/        # Komponen Reusable
```

---

## 📝 Lisensi
Distribusi di bawah MIT License. Lihat `LICENSE` untuk informasi lebih lanjut.

---

## 💡 Saran Nama Repository
Jika Anda bingung memilih nama repo, berikut rekomendasinya:
- `AI-Content-Studio-UMKM` (Resmi/Deskriptif)
- `WiraCipta-AI` (Khas Indonesia)
- `Smart-UMKM-Studio` (Modern)
- `UMKM-Content-Genie` (Unik)

---
*Dibuat untuk memajukan UMKM Indonesia di era digital.*
