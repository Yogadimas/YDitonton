#!/usr/bin/env bash

echo -e "\033[1;36mMemulai proses flutter pub get untuk semua modul...\033[0m"

# Array dari modul-modul yang ada
modules=("core" "movie" "tv" "search" "about")

# Mengambil dependensi di root project
echo -e "\n\033[1;34m=========================================================================\033[0m"
echo -e "\033[1;32mMendapatkan dependensi pada root project...\033[0m"
echo -e "\033[1;34m=========================================================================\033[0m"
flutter pub get

# Melakukan perulangan ke masing-masing modul
for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo -e "\n\033[1;34m=========================================================================\033[0m"
        echo -e "\033[1;32mMendapatkan dependensi pada modul: \033[1;33m$module\033[0m"
        echo -e "\033[1;34m=========================================================================\033[0m"
        # Menggunakan subshell agar direktori tetap aman jika terjadi error
        (cd "$module" && flutter pub get)
    else
        echo -e "\033[1;33mPeringatan: Modul $module tidak ditemukan, dilewati.\033[0m"
    fi
done

echo -e "\n\033[1;34m=========================================================================\033[0m"
echo -e "\033[1;32mSelesai! Semua dependensi berhasil diunduh.\033[0m"
echo -e "\033[1;34m=========================================================================\033[0m"
