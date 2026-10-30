#!/bin/bash
# ==============================================================================
# One-Line Automated Installer for Immich SBC Optimizer & Tool
# Supports: ODROID-C2 / Low-End ARM64 SBCs / DietPi / Debian / Ubuntu
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/faisalfa123/immich-odroid-c2/main/install.sh | sudo bash
# ==============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}"
echo "  ___                 _      _       ___ ___   ____ "
echo " |_ _|_ __  _ __ ___ (_) ___| |__   / __| _ ) / ___|"
echo "  | || '_ \| '_ \` _ \| |/ __| '_ \  \__ \ _ \ | |    "
echo "  | || | | | | | | | | | (__| | | | |___/___/ | |___ "
echo " |___|_| |_|_| |_| |_|_|\___|_| |_|          \____|"
echo -e "${NC}"
echo -e "${CYAN}🚀 Memasang Immich SBC Optimizer & Tool untuk ODROID-C2...${NC}\n"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}❌ Error: Script instalasi ini harus dijalankan sebagai root (sudo bash).${NC}"
    exit 1
fi

INSTALL_DIR="/opt/immich-sbc-tool"
BIN_LINK="/usr/local/bin/immich-sbc-tool"

mkdir -p "$INSTALL_DIR/bin"
mkdir -p "$INSTALL_DIR/config"
mkdir -p "$INSTALL_DIR/hooks"
mkdir -p "$INSTALL_DIR/tests"
mkdir -p "/var/backups/immich"

SCRIPT_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

if [ -f "$SCRIPT_SOURCE_DIR/bin/immich-sbc-tool" ]; then
    echo -e "📦 Menyalin berkas instalasi dari media lokal..."
    cp -rf "$SCRIPT_SOURCE_DIR"/* "$INSTALL_DIR/"
else
    echo -e "🌐 Mengunduh komponen terbaru dari GitHub repository..."
    BASE_URL="https://raw.githubusercontent.com/faisalfa123/immich-odroid-c2/main"
    curl -fsSL "$BASE_URL/bin/immich-sbc-tool" -o "$INSTALL_DIR/bin/immich-sbc-tool"
    curl -fsSL "$BASE_URL/config/docker-compose.low-ram.yml" -o "$INSTALL_DIR/config/docker-compose.low-ram.yml"
    curl -fsSL "$BASE_URL/config/immich.env.template" -o "$INSTALL_DIR/config/immich.env.template"
    curl -fsSL "$BASE_URL/config/postgresql-sbc.conf" -o "$INSTALL_DIR/config/postgresql-sbc.conf"
    curl -fsSL "$BASE_URL/hooks/bumiayu-integration.sh" -o "$INSTALL_DIR/hooks/bumiayu-integration.sh"
    curl -fsSL "$BASE_URL/tests/test-formats.sh" -o "$INSTALL_DIR/tests/test-formats.sh"
fi

chmod +x "$INSTALL_DIR/bin/immich-sbc-tool"
chmod +x "$INSTALL_DIR/hooks/bumiayu-integration.sh"
chmod +x "$INSTALL_DIR/tests/test-formats.sh"

ln -sfn "$INSTALL_DIR/bin/immich-sbc-tool" "$BIN_LINK"

# Jalankan integrasi ke Bumiayu TUI jika tersedia di sistem
if [ -f "$INSTALL_DIR/hooks/bumiayu-integration.sh" ]; then
    bash "$INSTALL_DIR/hooks/bumiayu-integration.sh" || true
fi

echo -e "\n${GREEN}✅ Instalasi Berhasil!${NC}"
echo -e "Anda sekarang dapat membuka toolkit kapan saja dengan mengetikkan perintah:"
echo -e "   ${BOLD}sudo immich-sbc-tool${NC}\n"
