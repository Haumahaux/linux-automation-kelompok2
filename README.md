# Otomasi dan Container Linux

## Modul: Disk Monitor
Script shell untuk memeriksa penggunaan disk dengan `df`, membandingkannya dengan ambang batas persentase, menampilkan status NORMAL atau PERINGATAN, dan mencatat hasilnya ke log.

## Prasyarat
Linux (atau WSL) dengan bash dan `df`.

## Cara menjalankan
```bash
cd disk-monitor
cp config/disk_monitor.conf.example config/disk_monitor.conf   # opsional
./disk_monitor.sh                      # nilai bawaan (ambang 80, path /)
./disk_monitor.sh -t 90 -p /home       # ambang 90 persen, periksa /home
./disk_monitor.sh -h                   # bantuan
```
Opsi: `-t` ambang batas (1-100), `-p` path, `-l` file log, `-h` bantuan.
Prioritas nilai: argumen > file konfigurasi > nilai bawaan.

## Exit status
| Kode | Arti |
|---|---|
| 0 | Normal |
| 1 | Peringatan, penggunaan mencapai atau melewati ambang batas |
| 2 | Input tidak valid |
| 3 | Error sistem (path tidak ada, log tidak bisa ditulis, df gagal) |

## Cara memverifikasi
```bash
cd disk-monitor
./disk_monitor.sh -t 100; echo "exit=$?"     # biasanya exit=0
./disk_monitor.sh -t abc; echo "exit=$?"     # exit=2
./tests/run_tests.sh                         # semua test harus PASS
cat logs/disk_monitor.log                    # isi log pemeriksaan
```

## Cara membersihkan
```bash
rm -f disk-monitor/logs/*.log
rm -f disk-monitor/config/disk_monitor.conf
```

## Rollback
```bash
git log --oneline                      # cari commit yang bermasalah
git revert <commit-id>                 # batalkan satu commit dengan aman
git checkout P2-CHECKPOINT-P11-v01     # lihat versi checkpoint ini
```

## Bukti pengujian
Lihat `disk-monitor/docs/hasil_uji.md`, `log_berhasil.log`, dan `log_gagal.log`.

## Struktur repository
```
disk-monitor/
├── disk_monitor.sh
├── lib/ (core.sh, validation.sh, logging.sh)
├── config/disk_monitor.conf.example
├── tests/run_tests.sh
├── docs/
└── logs/
```

## Kontribusi anggota
| Anggota | Nama | Peran | Kontribusi |
|---|---|---|---|
| 1 | Raihan | Inti script | `disk_monitor.sh`, `lib/core.sh`: pembacaan df, penentuan status, exit status |
| 2 | Allisya Eka Nur | Validasi, log, konfigurasi | `lib/validation.sh`, `lib/logging.sh`, `config/`: validasi input, log, error handling |
| 3 | Malva Nurul Fitria | Pengujian | `tests/run_tests.sh`, `docs/`: 5 test case, log berhasil dan gagal, interpretasi |
| 4 | Denzel Immanuel Marpaung | Repository dan dokumentasi | Setup repository, `README.md`, review, tag rilis, pengumpulan |

Jumlah commit tiap anggota dapat dilihat dengan `git shortlog -sn --all`.
