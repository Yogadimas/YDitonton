#!/usr/bin/env bash

echo -e "\033[1;36mMemulai proses flutter clean untuk semua modul...\033[0m"

# Array dari modul-modul yang ada
modules=("core" "movie" "tv" "search" "about")

# Membersihkan file build di root project
echo -e "\n\033[1;34m=========================================================================\033[0m"
echo -e "\033[1;32mMembersihkan file build pada root project...\033[0m"
echo -e "\033[1;34m=========================================================================\033[0m"
flutter clean

# Melakukan perulangan ke masing-masing modul
for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo -e "\n\033[1;34m=========================================================================\033[0m"
        echo -e "\033[1;32mMembersihkan file build pada modul: \033[1;33m$module\033[0m"
        echo -e "\033[1;34m=========================================================================\033[0m"
        (cd "$module" && flutter clean)
    else
        echo -e "\033[1;33mPeringatan: Modul $module tidak ditemukan, dilewati.\033[0m"
    fi
done

echo -e "\n\033[1;34m=========================================================================\033[0m"
echo -e "\033[1;32mSelesai! Semua file build berhasil dibersihkan.\033[0m"
echo -e "\033[1;34m=========================================================================\033[0m"
