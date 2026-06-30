# Hermes Cloud Deployment Workspace

Este espacio de trabajo contiene la documentación y las herramientas necesarias para configurar y desplegar el **Hermes Agent** (de Nous Research) en la nube de manera 100% gratuita, utilizando el modelo de lenguaje gratuito de alto rendimiento **Hermes 3 405B**.

## Estructura del Workspace

El espacio de trabajo está organizado de la siguiente manera:

*   **`docs/`**
    *   [HERMES_DOCUMENTATION.md](file:///c:/Users/Nafer/Desktop/proyectos/HERMES/docs/HERMES_DOCUMENTATION.md): Documentación técnica profunda sobre el agente (arquitectura, comandos, configuración del archivo `config.yaml` y `.env`).
    *   [FREE_CLOUD_DEPLOYMENT.md](file:///c:/Users/Nafer/Desktop/proyectos/HERMES/docs/FREE_CLOUD_DEPLOYMENT.md): Manual paso a paso para desplegar en plataformas cloud gratuitas (GCP, Oracle Cloud, Hugging Face) y conectar con OpenRouter.
*   **`scripts/`**
    *   [setup_environment.sh](file:///c:/Users/Nafer/Desktop/proyectos/HERMES/scripts/setup_environment.sh): Script automatizado en Bash para configurar dependencias e instalar el agente en servidores Linux (Debian/Ubuntu).
    *   [hermes.service](file:///c:/Users/Nafer/Desktop/proyectos/HERMES/scripts/hermes.service): Plantilla de Systemd para mantener el bot activo 24/7 en segundo plano.
*   **`Dockerfile`**: Plantilla de contenedor lista para hosting en la nube basado en contenedores (ej. Hugging Face Spaces o Render).

---

## Hoja de Ruta Rápida para Despliegue (Quickstart)

Si deseas levantar el agente conectado a un bot de Telegram utilizando recursos gratuitos en menos de 10 minutos, sigue estos pasos rápidos:

1.  **Obtener claves y tokens:**
    *   Crea una cuenta en [OpenRouter](https://openrouter.ai/) y genera una clave API gratuita.
    *   En Telegram, abre una conversación con [@BotFather](https://t.me/BotFather), escribe `/newbot` y obtén tu token de bot.
    *   Obtén tu ID numérico de Telegram usando un bot como [@userinfobot](https://t.me/userinfobot).

2.  **Desplegar en el Servidor (VPS):**
    *   Crea una instancia gratuita en **Google Cloud Platform (e2-micro)** u **Oracle Cloud (Ampere A1)** con Ubuntu.
    *   Sube el script `scripts/setup_environment.sh` y ejecútalo para instalar todas las dependencias.

3.  **Configurar el Agente:**
    *   Ejecuta `hermes setup` en tu terminal de servidor y sigue los pasos para configurar el modelo (elige OpenRouter y el modelo `nousresearch/hermes-3-llama-3.1-405b:free`).
    *   Ejecuta `hermes gateway setup` para ingresar las credenciales del bot de Telegram que obtuviste en el paso 1.

4.  **Hacerlo Persistente (24/7):**
    *   Copia el archivo `scripts/hermes.service` al directorio `/etc/systemd/system/` en tu servidor.
    *   Ejecuta `sudo systemctl enable --now hermes` para iniciar el bot en segundo plano.

*Para detalles profundos y configuraciones personalizadas de otros servicios (Discord, Slack, Hugging Face), consulta la carpeta `docs/`.*
