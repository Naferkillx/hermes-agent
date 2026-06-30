#!/usr/bin/env bash

# Script de instalación automatizada para Hermes Agent en Debian/Ubuntu
# Nous Research Hermes Agent Setup

set -e # Detener ejecución ante cualquier error

# Colores para la salida
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}    Instalación y Configuración de Hermes Agent     ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# 1. Verificar si el sistema es Debian o Ubuntu
if [ -f /etc/debian_version ]; then
    echo -e "${GREEN}[+] Sistema Debian/Ubuntu detectado.${NC}"
else
    echo -e "${YELLOW}[!] Advertencia: Este script fue diseñado para Ubuntu/Debian. Continuando de todas formas...${NC}"
fi

# 2. Actualizar el gestor de paquetes e instalar dependencias básicas
echo -e "${BLUE}[2/4] Actualizando paquetes e instalando dependencias (curl, git, python3, pip, venv)...${NC}"
sudo apt-get update -y
sudo apt-get install -y curl git python3 python3-pip python3-venv build-essential libffi-dev libssl-dev

# 3. Descargar e instalar Hermes Agent a nivel global
echo -e "${BLUE}[3/4] Instalando el ejecutable global de Hermes Agent...${NC}"
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Registrar variables de entorno de la instalación
if [ -f "$HOME/.bashrc" ]; then
    # Intentar cargar la configuración en la sesión actual
    export PATH="$PATH:$HOME/.local/bin"
fi

# 4. Crear directorio de espacio de trabajo para el agente
echo -e "${BLUE}[4/4] Creando directorios locales de trabajo...${NC}"
mkdir -p ~/hermes_workspace
mkdir -p ~/.hermes

echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}   ¡Instalación de dependencias completada con éxito!${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo ""
echo -e "${YELLOW}Próximos pasos requeridos:${NC}"
echo -e "  1. Recarga tu terminal actual:"
echo -e "     ${BLUE}source ~/.bashrc${NC}"
echo -e "  2. Configura tu modelo gratuito de OpenRouter o local de Ollama:"
echo -e "     ${BLUE}hermes setup${NC}"
echo -e "  3. Configura la pasarela de Telegram o tu chat preferido:"
echo -e "     ${BLUE}hermes gateway setup${NC}"
echo -e "  4. Inicia el gateway para probar la conexión en vivo:"
echo -e "     ${BLUE}hermes gateway start${NC}"
echo ""
echo -e "Para configurar el inicio persistente 24/7 en segundo plano,"
echo -e "puedes utilizar el archivo de servicio provisto en ${BLUE}scripts/hermes.service${NC}."
echo ""
