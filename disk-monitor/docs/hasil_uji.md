# Hasil Pengujian Disk Monitor

- Lingkungan: (contoh: Ubuntu 24.04 di WSL2, bash versi ...)
- Tanggal uji: (isi)
- Commit yang diuji: (isi, lihat dengan `git rev-parse --short HEAD`)

| No | Test case | Input | Exit diharapkan | Exit aktual | Status |
|---|---|---|---|---|---|
| T1 | Normal | -t 100 | 0 | | |
| T2 | Peringatan | -t 1 | 1 | | |
| T3 | Ambang berupa teks | -t abc | 2 | | |
| T4 | Ambang 150 | -t 150 | 2 | | |
| T5 | Path tidak ada | -p /path/tidak/ada | 3 | | |

## Output terminal
(tempel keluaran dari `./tests/run_tests.sh`)

## Interpretasi
(1 sampai 2 kalimat per test: apa artinya hasil itu. Contoh: T3 ditolak dengan exit 2 karena teks bukan bilangan bulat, dan alasannya tercatat di log_gagal.log.)
