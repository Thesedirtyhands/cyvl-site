#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-8000}"
HOST="${HOST:-0.0.0.0}"
SITE_DIR="${SITE_DIR:-website}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVE_DIR="${ROOT_DIR}/${SITE_DIR}"
LOCAL_URL="http://localhost:${PORT}/"
LOOPBACK_URL="http://127.0.0.1:${PORT}/"

open_url() {
  local target="$1"

  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$target" >/dev/null 2>&1 &
    return 0
  fi

  if command -v open >/dev/null 2>&1; then
    open "$target" >/dev/null 2>&1 &
    return 0
  fi

  if command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -Command "Start-Process '$target'" >/dev/null 2>&1
    return 0
  fi

  return 1
}

first_lan_ip() {
  if command -v hostname >/dev/null 2>&1; then
    hostname -I 2>/dev/null | awk '{print $1}'
  fi
}

if [[ ! -d "$SERVE_DIR" ]]; then
  echo "Error: site directory not found: $SERVE_DIR" >&2
  echo "Tip: set SITE_DIR to the folder you want to serve, e.g. SITE_DIR=. ./scripts/dev-preview.sh" >&2
  exit 1
fi

cd "$ROOT_DIR"

echo "Starting CYVL dev preview"
echo "- Serving directory: ${SERVE_DIR}"
echo "- Binding host: ${HOST}"
echo "- Port: ${PORT}"
echo "- Site URL: ${LOCAL_URL}"
echo "- Loopback URL: ${LOOPBACK_URL}"

LAN_IP="$(first_lan_ip || true)"
if [[ -n "${LAN_IP}" ]]; then
  echo "- LAN URL: http://${LAN_IP}:${PORT}/"
fi

if open_url "$LOCAL_URL" || open_url "$LOOPBACK_URL"; then
  echo "Opened browser automatically."
else
  echo "Could not auto-open a browser in this environment."
fi

echo "If this is WSL/VM/container, open the URL from your host machine browser."
echo "Press Ctrl+C to stop."
exec python3 -m http.server "$PORT" --bind "$HOST" --directory "$SERVE_DIR"
