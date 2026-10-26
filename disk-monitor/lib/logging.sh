#!/usr/bin/env bash
# logging.sh: konfigurasi, log, dan penanganan error

# Membaca file konfigurasi format KEY=VALUE (tanpa mengeksekusi isinya).
load_config() {
    local file="$1" key value
    [[ -f "$file" ]] || return 0
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
        value="${value%\"}"; value="${value#\"}"
        case "$key" in
            THRESHOLD)   THRESHOLD="$value" ;;
            TARGET_PATH) TARGET_PATH="$value" ;;
            LOG_FILE)    LOG_FILE="$value" ;;
        esac
    done < "$file"
}

# Menyiapkan file log. Return 1 jika folder atau file tidak bisa dibuat.
init_log() {
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null && touch "$LOG_FILE" 2>/dev/null
}

# Format: [tanggal jam] [LEVEL] pesan
write_log() {
    local level="$1"; shift
    printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" >> "$LOG_FILE" 2>/dev/null
}

# Cetak error ke stderr, catat ke log, lalu keluar dengan kode tertentu.
die() {
    local code="$1"; shift
    echo "ERROR: $*" >&2
    write_log "ERROR" "$* (exit=$code)"
    exit "$code"
}
