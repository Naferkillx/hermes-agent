#!/usr/bin/env bash
set -e

echo "[+] Iniciando contenedor Docker de Hermes Agent..."

# Crear directorios necesarios
mkdir -p ~/.hermes
mkdir -p ~/hermes_workspace

# Generar archivo config.yaml dinámicamente usando Python si no existe
echo "[+] Configurando archivo config.yaml..."
python3 -c "
import os, yaml
config_path = os.path.expanduser('~/.hermes/config.yaml')
if not os.path.exists(config_path):
    config = {
        'model': {
            'default': os.environ.get('DEFAULT_MODEL', 'nousresearch/hermes-3-llama-3.1-405b:free'),
            'provider': os.environ.get('LLM_PROVIDER', 'openrouter'),
            'base_url': os.environ.get('BASE_URL', 'https://openrouter.ai/v1'),
            'temperature': float(os.environ.get('MODEL_TEMPERATURE', '0.7'))
        },
        'terminal': {
            'backend': 'local',
            'workdir': os.path.expanduser('~/hermes_workspace')
        },
        'memory': {
            'memory_enabled': True,
            'user_profile_enabled': True
        }
    }
    with open(config_path, 'w') as f:
        yaml.dump(config, f)
    print('[+] Archivo config.yaml creado exitosamente.')
else:
    print('[~] Archivo config.yaml existente detectado. Omitiendo creación.')
"

# Generar archivo .env dinámicamente para las claves y tokens
echo "[+] Generando archivo de credenciales .env..."
cat <<EOF > ~/.hermes/.env
OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_USER_ID=${TELEGRAM_USER_ID}
DISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN}
EOF
chmod 600 ~/.hermes/.env

echo "[+] Configuración completada. Iniciando Hermes Gateway..."

# Iniciar un servidor HTTP dummy en segundo plano en el puerto que Render asigna
# Esto evita que Render falle por el escaneo de puertos y permite mantener el servicio despierto
echo "[+] Iniciando servidor HTTP dummy en el puerto ${PORT:-8080}..."
python3 -m http.server ${PORT:-8080} &

# Ejecutar el gateway del agente
exec hermes gateway run
