#!/usr/bin/env bash
# validation.sh: argumen dan validasi input

usage() {
    cat <<EOF
Penggunaan: disk_monitor.sh [-t ambang] [-p path] [-l file_log] [-h]
  -t  Ambang batas persen, bilangan bulat 1-100 (bawaan: 80)
  -p  Path yang diperiksa (bawaan: /)
  -l  File log (bawaan: logs/disk_monitor.log)
  -h  Tampilkan bantuan
Exit status: 0 normal, 1 peringatan, 2 input tidak valid, 3 error sistem
EOF
}

parse_args() {
    local opt
    OPTIND=1
    while getopts ":t:p:l:h" opt; do
        case "$opt" in
            t) THRESHOLD="$OPTARG" ;;
            p) TARGET_PATH="$OPTARG" ;;
            l) LOG_FILE="$OPTARG" ;;
            h) usage; exit "$EXIT_OK" ;;
            :)  echo "ERROR: opsi -$OPTARG membutuhkan nilai" >&2; usage >&2; exit "$EXIT_INVALID_INPUT" ;;
            \?) echo "ERROR: opsi tidak dikenal: -$OPTARG" >&2; usage >&2; exit "$EXIT_INVALID_INPUT" ;;
        esac
    done
}

# Valid jika bilangan bulat 1-100.
validate_threshold() {
    local value="$1"
    [[ "$value" =~ ^[0-9]+$ ]] || return 1
    (( 10#$value >= 1 && 10#$value <= 100 ))
}

# Valid jika path ada.
validate_path() {
    [[ -n "$1" && -e "$1" ]]
}
