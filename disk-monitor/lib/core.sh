#!/usr/bin/env bash
# core.sh: fungsi inti pemeriksaan disk

# Mencetak persentase penggunaan disk (angka saja) untuk path tertentu.
get_disk_usage() {
    local path="$1" output
    output="$(df -P "$path" 2>/dev/null)" || return 1
    echo "$output" | awk 'NR==2 {gsub("%","",$5); print $5}'
}

# Mencetak NORMAL atau WARNING. WARNING jika penggunaan >= ambang batas.
evaluate_status() {
    local used_pct="$1" threshold="$2"
    if (( used_pct >= threshold )); then
        echo "WARNING"
    else
        echo "NORMAL"
    fi
}
