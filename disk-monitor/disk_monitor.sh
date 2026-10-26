#!/usr/bin/env bash
# disk_monitor.sh: memeriksa penggunaan disk dan memberi peringatan
# jika melewati ambang batas.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly EXIT_OK=0
readonly EXIT_WARNING=1
readonly EXIT_INVALID_INPUT=2
readonly EXIT_SYSTEM_ERROR=3

# Nilai bawaan (bisa diubah lewat file konfigurasi atau argumen)
THRESHOLD=80
TARGET_PATH="/"
LOG_FILE="logs/disk_monitor.log"
CONFIG_FILE="$SCRIPT_DIR/config/disk_monitor.conf"

source "$SCRIPT_DIR/lib/logging.sh"
source "$SCRIPT_DIR/lib/validation.sh"
source "$SCRIPT_DIR/lib/core.sh"

main() {
    load_config "$CONFIG_FILE"
    parse_args "$@"

    # Path relatif untuk log dihitung dari folder script
    [[ "$LOG_FILE" = /* ]] || LOG_FILE="$SCRIPT_DIR/$LOG_FILE"

    init_log || die "$EXIT_SYSTEM_ERROR" "Log tidak bisa ditulis: $LOG_FILE"

    write_log "INFO" "Pemeriksaan dimulai (path=$TARGET_PATH, ambang=$THRESHOLD)"

    validate_threshold "$THRESHOLD" \
        || die "$EXIT_INVALID_INPUT" "Ambang batas tidak valid: '$THRESHOLD' (harus bilangan bulat 1-100)"
    validate_path "$TARGET_PATH" \
        || die "$EXIT_SYSTEM_ERROR" "Path tidak ditemukan: '$TARGET_PATH'"

    local used_pct status
    used_pct="$(get_disk_usage "$TARGET_PATH")" \
        || die "$EXIT_SYSTEM_ERROR" "Perintah df gagal untuk path: '$TARGET_PATH'"
    [[ "$used_pct" =~ ^[0-9]+$ ]] \
        || die "$EXIT_SYSTEM_ERROR" "Hasil df tidak bisa dibaca: '$used_pct'"

    status="$(evaluate_status "$used_pct" "$THRESHOLD")"

    if [[ "$status" == "WARNING" ]]; then
        echo "PERINGATAN: penggunaan $TARGET_PATH ${used_pct}% (ambang ${THRESHOLD}%)"
        write_log "WARNING" "Penggunaan ${used_pct}% >= ambang ${THRESHOLD}% pada $TARGET_PATH"
        exit "$EXIT_WARNING"
    fi

    echo "NORMAL: penggunaan $TARGET_PATH ${used_pct}% (ambang ${THRESHOLD}%)"
    write_log "INFO" "Penggunaan ${used_pct}% < ambang ${THRESHOLD}% pada $TARGET_PATH"
    exit "$EXIT_OK"
}

main "$@"
