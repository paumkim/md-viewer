#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
APPS_DIR="${HOME}/.local/share/applications"

echo "==> md-viewer installer"
echo ""

# --- Python check ---
if ! command -v python3 &>/dev/null; then
    echo "Error: python3 not found. Please install Python 3 first."
    exit 1
fi

# --- Install Python dependency ---
echo "==> Installing Python dependencies..."
if python3 -c "import markdown" 2>/dev/null; then
    echo "  ✓ markdown library already available"
else
    echo "  Installing markdown library..."
    pip3 install --user -r "${PROJECT_DIR}/requirements.txt" 2>/dev/null \
        || pip3 install -r "${PROJECT_DIR}/requirements.txt" 2>/dev/null \
        || {
        echo "  ! pip3 install failed. Trying alternative methods..."
        if command -v pacman &>/dev/null; then
            echo "  Detected Arch Linux. Run: sudo pacman -S python-markdown"
        elif command -v apt &>/dev/null; then
            echo "  Detected Debian/Ubuntu. Run: sudo apt install python3-markdown"
        elif command -v dnf &>/dev/null; then
            echo "  Detected Fedora. Run: sudo dnf install python3-markdown"
        else
            echo "  Run: pip3 install markdown  (or use your distro's package manager)"
        fi
        echo "  After installing, re-run this script."
        exit 1
    }
fi
echo ""

# --- Symlink script ---
echo "==> Installing md2html to ${BIN_DIR}/..."
mkdir -p "${BIN_DIR}"
if [ -f "${BIN_DIR}/md2html" ] && [ ! -L "${BIN_DIR}/md2html" ]; then
    echo "  Warning: ${BIN_DIR}/md2html already exists (not a symlink)."
    echo "  Backing up to ${BIN_DIR}/md2html.bak"
    mv "${BIN_DIR}/md2html" "${BIN_DIR}/md2html.bak"
fi
chmod +x "${PROJECT_DIR}/md2html"
ln -sf "${PROJECT_DIR}/md2html" "${BIN_DIR}/md2html"
echo "  Done: ${BIN_DIR}/md2html -> ${PROJECT_DIR}/md2html"
echo ""

# --- Register .desktop handler ---
echo "==> Registering .md file handler..."
mkdir -p "${APPS_DIR}"
cp "${PROJECT_DIR}/mdviewer.desktop" "${APPS_DIR}/mdviewer.desktop"

if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
fi
if command -v xdg-mime &>/dev/null; then
    xdg-mime default mdviewer.desktop text/markdown 2>/dev/null || true
    xdg-mime default mdviewer.desktop text/x-markdown 2>/dev/null || true
fi
echo "  Done: ${APPS_DIR}/mdviewer.desktop"
echo ""

# --- Verify ---
echo "==> Verifying installation..."
if command -v md2html &>/dev/null; then
    echo "  ✓ md2html found in PATH"
else
    echo "  ! md2html not in PATH. Add ${BIN_DIR} to your PATH or log out and back in."
fi
if [ -f "${APPS_DIR}/mdviewer.desktop" ]; then
    echo "  ✓ Desktop file registered"
fi
python3 -c "import markdown; print('  ✓ markdown library (v' + markdown.__version__ + ')')" 2>/dev/null || {
    echo "  ✗ markdown library not available"
}
echo ""

echo "==> Done! Try it:"
echo "    md2html path/to/file.md"
echo "    Or double-click a .md file in your file manager."
