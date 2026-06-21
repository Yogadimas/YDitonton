#!/usr/bin/env bash

# https://medium.com/@nocnoc/combined-code-coverage-for-flutter-and-dart-237b9563ecf8

# Mengingat beberapa perintah yang gagal dan melaporkannya saat keluar
error=false

show_help() {
  printf "penggunaan: $0 [--help]
Alat untuk menjalankan semua pengujian unit dan widget beserta cakupan kode (coverage), serta otomatis membuat laporan HTML jika lcov terinstal.

(jalankan dari root repositori)
di mana:
    --help
        menampilkan pesan bantuan ini
"
  exit 1
}

# Menjalankan pengujian unit dan widget
runTests() {
  cd $1
  if [ -f "pubspec.yaml" ] && [ -d "test" ]; then
    echo -e "\n\033[1;34m=========================================================================\033[0m"
    echo -e "\033[1;32mMenjalankan pengujian pada direktori: \033[1;33m$1\033[0m"
    echo -e "\033[1;34m=========================================================================\033[0m"
    flutter pub get

    escapedPath="$(echo $1 | sed 's/\//\\\//g')"

    # Menjalankan pengujian beserta cakupan kode (coverage)
    if grep flutter pubspec.yaml >/dev/null; then
      echo -e "\033[1;36mMemulai proses pengujian flutter...\033[0m"
      if [ -f "test/all_tests.dart" ]; then
        flutter test --coverage --concurrency=1 test/all_tests.dart || error=true
      else
        flutter test --coverage --concurrency=1 || error=true
      fi

      if [ -d "coverage" ]; then
        # Memastikan direktori coverage di root sudah ada
        mkdir -p "$2/coverage"
        # Menggabungkan info cakupan baris dari pengujian paket ke file umum
        sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >>$2/coverage/test.info
        rm -f coverage/lcov.info
      fi
    else
      echo -e "\033[1;33mPeringatan: Bukan paket flutter, dilewati.\033[0m"
    fi
  fi
  cd - >/dev/null
}

runReport() {
  echo -e "\n\033[1;34m=========================================================================\033[0m"
  echo -e "\033[1;32mMembuat laporan cakupan kode (coverage)...\033[0m"
  echo -e "\033[1;34m=========================================================================\033[0m"
  
  if [ -f "coverage/test.info" ] && ! [ "$TRAVIS" ]; then
    # Memperbaiki format path agar kompatibel dengan Windows
    sed -i 's/\\/\//g' coverage/test.info
    
    if command -v genhtml &> /dev/null; then
      genhtml coverage/test.info -o coverage --no-function-coverage --prefix $(pwd)

      if [ "$(uname)" == "Darwin" ]; then
        open coverage/index.html
      else
        start coverage/index.html
      fi
    else
      echo -e "\033[1;33mPeringatan: genhtml (lcov) tidak terinstal. Pembuatan laporan HTML dilewati.\033[0m"
      echo -e "Informasi cakupan kode tersedia di \033[1;36mcoverage/test.info\033[0m"
    fi
  fi
}

if ! [ -f "pubspec.yaml" ] && [ -d .git ]; then
  printf "\nKesalahan: Tidak berada di root repositori\n"
  show_help
fi

case $1 in
--help)
  show_help
  ;;
*)
  currentDir=$(pwd)
  # Jika tidak ada parameter yang diberikan
  if [ -z $1 ]; then
    if [ -d "coverage" ]; then
      rm -r coverage
    fi
    dirs=($(find . -maxdepth 2 -type d))
    for dir in "${dirs[@]}"; do
      runTests $dir $currentDir
    done
  else
    if [[ -d "$1" ]]; then
      runTests $1 $currentDir
    else
      printf "\nKesalahan: Bukan sebuah direktori: $1\n"
      show_help
    fi
  fi
  runReport
  ;;
esac

# Gagalkan proses build jika terdapat kesalahan
if [ "$error" = true ]; then
  echo -e "\n\033[1;31mKesalahan: Beberapa pengujian gagal!\033[0m"
  read -p "Tekan Enter untuk keluar..."
  exit -1
fi

echo -e "\n\033[1;32mSelesai! Semua pengujian berhasil dijalankan.\033[0m"
read -p "Tekan Enter untuk keluar..."
