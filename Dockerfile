# Usar una imagen oficial de Python ligera como base
FROM python:3.11-slim

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Crear un usuario no-root para ejecutar el agente de forma segura
RUN useradd -m -u 1000 hermes
USER hermes
WORKDIR /home/hermes

# Establecer variables de entorno
ENV PATH="/home/hermes/.local/bin:${PATH}"
ENV HOME="/home/hermes"

# Instalar Hermes Agent a nivel de usuario
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Instalar PyYAML para el script de configuración dinámico en el entrypoint
RUN pip install --user --no-cache-dir pyyaml

# Copiar el script de entrada (entrypoint) y darle permisos
COPY --chown=hermes:hermes scripts/entrypoint.sh /home/hermes/entrypoint.sh
RUN chmod +x /home/hermes/entrypoint.sh

# Exponer el puerto por si se requiere alguna interfaz web (opcional)
EXPOSE 7860

# Configurar el entrypoint para automatizar la inicialización
ENTRYPOINT ["/home/hermes/entrypoint.sh"]
