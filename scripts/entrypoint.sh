#!/usr/bin/env bash
set -e


echo "[+] Iniciando contenedor Docker de Hermes Agent..."


# Crear directorios necesarios
mkdir -p ~/.hermes
mkdir -p ~/hermes_workspace


# Generar archivo config.yaml dinámicamente usando Python
echo "[+] Configurando archivo config.yaml..."
python3 -c "
import os, yaml
config_path = os.path.expanduser('~/.hermes/config.yaml')
# Siempre sobreescribimos la configuración para aplicar las variables de entorno de Render
config = {
    'model': {
        'default': os.environ.get('DEFAULT_MODEL', 'google/gemma-3-27b-it:free'),
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
print('[+] Archivo config.yaml configurado exitosamente.')
"
