#!/bin/bash

# Usuario que va a usar Docker
USUARIO="user"

echo "[*] Paso 1: Instalando dependencias necesarias..."
apt update
apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common \
    ufw

echo "[*] Paso 2: Agregando clave GPG y repositorio oficial de Docker..."
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[*] Paso 3: Instalando Docker Engine y plugins..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[*] Paso 4: Habilitando e iniciando el servicio Docker..."
systemctl enable docker
systemctl start docker

echo "[*] Paso 5: Agregando el usuario '$USUARIO' al grupo docker..."
usermod -aG docker "$USUARIO"

echo "[*] Paso 6: Configurando el firewall (UFW)..."

# Habilitar SSH (por si no está aún)
ufw allow OpenSSH

# Puertos web comunes para contenedores básicos
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS

# Activar UFW con confirmación automática
ufw --force enable

echo "[✔] Docker instalado, firewall configurado y permisos aplicados."
echo "[→] Reiniciá sesión con '$USUARIO' para poder usar Docker sin sudo."
