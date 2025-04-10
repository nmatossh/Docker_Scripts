#!/bin/bash

echo "🔍 Verificando instalación de Docker..."

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
  echo "❌ Docker no está instalado o no está en el PATH."
  exit 1
fi

# Verificar estado del servicio Docker
echo -n "⏳ Comprobando estado del servicio Docker... "
if systemctl is-active --quiet docker; then
  echo "✅ Activo"
else
  echo "❌ Inactivo"
  systemctl status docker
  exit 1
fi

# Verificar acceso sin sudo
echo -n "⏳ Comprobando acceso sin sudo... "
if docker info &> /dev/null; then
  echo "✅ Tu usuario puede usar Docker"
else
  echo "❌ No podés usar Docker sin sudo. ¿Agregaste tu usuario al grupo docker?"
  echo "👉 Recordá hacer: sudo usermod -aG docker $USER && cerrar sesión o reiniciar"
  exit 1
fi

# Verificar Docker Compose plugin
echo -n "⏳ Verificando Docker Compose... "
if docker compose version &> /dev/null; then
  echo "✅ Docker Compose disponible"
else
  echo "❌ Docker Compose no disponible o no es el plugin oficial"
  exit 1
fi

# Probar contenedor hello-world
echo "⏳ Probando ejecución de contenedor hello-world..."
if docker run --rm hello-world &> /dev/null; then
  echo "✅ Docker ejecuta contenedores correctamente"
else
  echo "❌ Falló la ejecución del contenedor hello-world"
  exit 1
fi

echo "🎉 Todo listo: Docker está correctamente instalado y funcional."
