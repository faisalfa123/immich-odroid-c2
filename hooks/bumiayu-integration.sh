#!/bin/bash
# ==============================================================================
# Hook Integrasi Immich SBC Tool ke Bumiayu TUI (https://github.com/faisalfa123/bumiayu-de.git)
# ==============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔗 Memasang Integrasi Immich SBC Optimizer ke Bumiayu TUI...${NC}"

# 1. Pastikan immich-sbc-tool terpasang di /usr/local/bin
TOOL_TARGET="/usr/local/bin/immich-sbc-tool"
if [ ! -f "$TOOL_TARGET" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/../bin/immich-sbc-tool" ]; then
        cp "$SCRIPT_DIR/../bin/immich-sbc-tool" "$TOOL_TARGET"
        chmod +x "$TOOL_TARGET"
        echo -e "${GREEN}✓ immich-sbc-tool disalin ke $TOOL_TARGET${NC}"
    else
        echo -e "${YELLOW}⚠️ immich-sbc-tool belum ada di /usr/local/bin. Mengunduh versi terbaru...${NC}"
        curl -fsSL https://raw.githubusercontent.com/faisalfa123/immich-odroid-c2/main/bin/immich-sbc-tool -o "$TOOL_TARGET" || true
        chmod +x "$TOOL_TARGET" 2>/dev/null || true
    fi
fi

# 2. Registrasi Hook Script ke Bumiayu Custom Apps
BUMIAYU_HOOK_DIR="/etc/bumiayu/hooks.d"
mkdir -p "$BUMIAYU_HOOK_DIR"

cat << 'EOF' > "$BUMIAYU_HOOK_DIR/immich.sh"
#!/bin/bash
# Hook wrapper untuk eksekusi Immich dari dalam Bumiayu TUI
clear
if command -v immich-sbc-tool >/dev/null 2>&1; then
    exec immich-sbc-tool
else
    echo "immich-sbc-tool tidak ditemukan di PATH."
    read -p "Tekan Enter untuk kembali ke Bumiayu TUI..."
fi
EOF
chmod +x "$BUMIAYU_HOOK_DIR/immich.sh"

echo -e "${GREEN}✅ Hook Bumiayu TUI berhasil didaftarkan di $BUMIAYU_HOOK_DIR/immich.sh!${NC}"
echo -e "   Pengguna dapat mengakses 'Immich SBC Manager' langsung dari terminal atau menu Bumiayu TUI.\n"
