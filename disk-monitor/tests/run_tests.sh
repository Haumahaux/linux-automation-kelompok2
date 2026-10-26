#!/usr/bin/env bash
# run_tests.sh: menjalankan semua test case Disk Monitor
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$SCRIPT_DIR/../disk_monitor.sh"
LOG_OK="$SCRIPT_DIR/../logs/test_berhasil.log"
LOG_ERR="$SCRIPT_DIR/../logs/test_gagal.log"
PASS=0
FAIL=0

# run_test <nama> <exit status diharapkan> <argumen script...>
run_test() {
    local name="$1" expected="$2" out actual
    shift 2
    out="$("$TARGET" "$@" 2>&1)"
    actual=$?
    if [[ "$actual" -eq "$expected" ]]; then
        echo "[PASS] $name (exit=$actual)"
        PASS=$((PASS + 1))
    else
        echo "[FAIL] $name (diharapkan=$expected, aktual=$actual)"
        FAIL=$((FAIL + 1))
    fi
    echo "       output: $out"
}

mkdir -p "$SCRIPT_DIR/../logs"
rm -f "$LOG_OK" "$LOG_ERR"

run_test "T1 berhasil: kondisi normal (ambang 100)"   0 -t 100 -p / -l "$LOG_OK"
run_test "T2 berhasil: kondisi peringatan (ambang 1)" 1 -t 1   -p / -l "$LOG_OK"
run_test "T3 gagal: ambang berupa teks"               2 -t abc -p / -l "$LOG_ERR"
run_test "T4 gagal: ambang 150 (di luar 1-100)"       2 -t 150 -p / -l "$LOG_ERR"
run_test "T5 gagal: path tidak ada"                   3 -t 80 -p /path/tidak/ada -l "$LOG_ERR"

echo "---"
echo "Ringkasan: $PASS lulus, $FAIL gagal"
[[ "$FAIL" -eq 0 ]]
