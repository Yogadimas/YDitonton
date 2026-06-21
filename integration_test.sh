#!/usr/bin/env bash

# Fungsi untuk menahan terminal agar tidak langsung tertutup
pause_and_exit() {
    echo ""
    read -p "Tekan Enter untuk menutup terminal..."
    exit $1
}

echo -e "\033[1;36mMemulai proses pengujian integrasi (integration test)...\033[0m"

echo -e "\n\033[1;34m=========================================================================\033[0m"
echo -e "\033[1;32mMenjalankan pengujian pada direktori: \033[1;33mintegration_test\033[0m"
echo -e "\033[1;34m=========================================================================\033[0m"

# Menjalankan pengujian integrasi (integration test)
if flutter test integration_test/app_test.dart; then
    echo -e "\n\033[1;34m=========================================================================\033[0m"
    echo -e "\033[1;32mSelesai! Semua pengujian integrasi berhasil dijalankan.\033[0m"
    echo -e "\033[1;34m=========================================================================\033[0m"
    pause_and_exit 0
else
    echo -e "\n\033[1;31mKesalahan: Beberapa pengujian integrasi gagal!\033[0m"
    pause_and_exit 1
fi
