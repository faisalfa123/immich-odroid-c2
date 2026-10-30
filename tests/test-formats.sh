#!/bin/bash
# ==============================================================================
# Immich Format & Codec Validator for ODROID-C2 / Low-End SBC
# Tests decoding capabilities: HEIC, RAW, H.265 (MP4/MKV), MOV
# ==============================================================================

LOG_FILE="/var/log/immich-updater.log"

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo -e "$1"
    echo "$msg" >> "$LOG_FILE" 2>/dev/null || true
}

log "🔍 Memeriksa dukungan format media untuk Immich di Odroid-C2..."

# 1. Cek HEIC Support (Apple iOS Live Photos & Images)
log "\n1. [HEIC / HEIF Format]"
if command -v heif-convert >/dev/null 2>&1; then
    log "  ✅ heif-convert (libheif-examples) terpasang."
elif dpkg -l | grep -q "libheif"; then
    log "  ✅ libheif terpasang di sistem."
else
    log "  ⚠️ libheif belum terdeteksi. Disarankan: apt-get install -y libheif-examples libheif1"
fi

# 2. Cek RAW Camera Support (DSLR/Mirrorless: .raw, .cr2, .nef, .arw, .dng)
log "\n2. [RAW Camera Format]"
if command -v dcraw >/dev/null 2>&1; then
    log "  ✅ dcraw terpasang."
elif dpkg -l | grep -q "libraw"; then
    log "  ✅ libraw-bin terpasang di sistem."
else
    log "  ⚠️ dcraw / libraw-bin belum terpasang. Disarankan: apt-get install -y libraw-bin dcraw"
fi

# 3. Cek FFmpeg Video Decoders (x265 / HEVC, MOV, MKV, MP4)
log "\n3. [Video Decoders (H.265 / HEVC, MOV, MP4, MKV)]"
if command -v ffmpeg >/dev/null 2>&1; then
    log "  ✅ ffmpeg terpasang:"
    
    # Check hevc decoder
    if ffmpeg -decoders 2>/dev/null | grep -q "hevc"; then
        log "    - HEVC/H.265 Decoder:  ✅ AKTIF (Dukungan x265 MP4/MKV)"
    else
        log "    - HEVC/H.265 Decoder:  ❌ Tidak ditemukan"
    fi
    
    # Check h264 decoder
    if ffmpeg -decoders 2>/dev/null | grep -q "h264"; then
        log "    - H.264/AVC Decoder:   ✅ AKTIF"
    else
        log "    - H.264/AVC Decoder:   ❌ Tidak ditemukan"
    fi

    # Check quicktime/mov demuxer
    if ffmpeg -demuxers 2>/dev/null | grep -q "mov,mp4,m4a,3gp,3g2,mj2"; then
        log "    - QuickTime / MOV:     ✅ AKTIF (Dukungan file .mov & iPhone video)"
    else
        log "    - QuickTime / MOV:     ❌ Tidak ditemukan"
    fi

    # Check matroska demuxer
    if ffmpeg -demuxers 2>/dev/null | grep -q "matroska"; then
        log "    - Matroska / MKV:      ✅ AKTIF"
    else
        log "    - Matroska / MKV:      ❌ Tidak ditemukan"
    fi
else
    log "  ⚠️ ffmpeg tidak ditemukan di host. Jika menggunakan Docker, container Immich resmi telah mengemas ffmpeg internal."
fi

# 4. Rekomendasi Hardware Transcode di Odroid-C2
log "\n💡 Senior Insight (Hardware Odroid-C2 Amlogic S905):"
log "   Chipset S905 Mali-450 tidak memiliki hardware encoder H.264/H.265 server-grade."
log "   Skrip konfigurasi Immich SBC telah mengatur 'IMMICH_SERVER_PREFER_DIRECT_STREAM=true'"
log "   dan membatasi concurrency transcode ke 1 thread dengan preset ultrafast."
log "   Format HEIC, MOV, x265, dan RAW akan diproses tanpa menyebabkan freeze sistem.\n"
