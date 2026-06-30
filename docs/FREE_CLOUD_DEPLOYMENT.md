# Manual de Despliegue en la Nube Gratis y Configuración del Mejor Modelo

Este manual te guiará paso a paso para configurar tu **Hermes Agent** en un entorno de ejecución continuo (24/7) en la nube de forma totalmente gratuita y utilizando el mejor LLM gratuito disponible.

---

## Paso 1: Configurar el Modelo de Lenguaje (LLM) Gratis

El agente de Hermes requiere un modelo inteligente para realizar llamadas a herramientas (habilidades). Configuraremos el modelo insignia gratuito de Nous Research: **Hermes 3 405B**.

### Opción Recomendada: OpenRouter API
OpenRouter ofrece un nivel gratuito de modelos muy potentes, incluyendo la versión completa de 405 mil millones de parámetros de Hermes 3.

1.  Ve a [OpenRouter.ai](https://openrouter.ai/).
2.  Inicia sesión o crea una cuenta gratuita.
3.  Ve a tu perfil y haz clic en **Keys** (Claves de API) -> **Create Key**. Guarda la clave generada en un bloc de notas seguro.
4.  El ID del modelo gratuito es:
    `nousresearch/hermes-3-llama-3.1-405b:free`
5.  *Nota:* Si en algún momento necesitas mayor velocidad sin límites, también puedes solicitar una API Key gratuita en [Google AI Studio](https://aistudio.google.com/) para usar `gemini-2.0-flash`.

---

## Paso 2: Crear el Bot de Mensajería (Telegram)

Para controlar a tu agente en la nube desde tu teléfono o PC, crearemos una pasarela de Telegram.

1.  En Telegram, busca a [@BotFather](https://t.me/BotFather) (la cuenta oficial con insignia de verificación).
2.  Escribe `/newbot`.
3.  Elige un nombre para tu bot (ej. `Mi Hermes Agente`).
4.  Elige un nombre de usuario único que termine en `bot` (ej. `mi_hermes_agent_bot`).
5.  BotFather te dará un **Token de Acceso HTTP** (ej. `123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ`). Guárdalo.
6.  Ahora busca el bot [@userinfobot](https://t.me/userinfobot) y envíale un mensaje para obtener tu **ID Numérico de Usuario** (ej. `987654321`). Esto evitará que otras personas hablen con tu bot en la nube.

---

## Paso 3: Elegir Plataforma de Hosting en la Nube Gratis

A continuación, tienes las tres mejores formas de hospedar tu bot 24/7 sin costo alguno:

---

### MODO A: Google Cloud Platform (GCP) - VM Permanente

GCP ofrece una máquina virtual pequeña pero 100% gratuita para siempre, perfecta para ejecutar el bot de Hermes conectado a la API de OpenRouter.

#### 1. Crear la Instancia de VM Gratis
1.  Inicia sesión en la consola de [Google Cloud](https://console.cloud.google.com/). Si es una cuenta nueva, te darán $300 en créditos adicionales (pero no los usaremos para mantenerlo gratis permanentemente).
2.  Navega a **Compute Engine** -> **Instancias de VM** -> **Crear instancia**.
3.  Configura los siguientes parámetros (críticos para calificar en el nivel gratuito):
    *   **Región:** Elige una de estas tres: `us-central1` (Iowa), `us-east1` (Carolina del Sur), o `us-west1` (Oregón).
    *   **Familia de máquina:** General Purpose -> **E2**.
    *   **Tipo de máquina:** Selecciona `e2-micro` (2 vCPUs compartidas, 1 GB de RAM).
    *   **Disco de arranque:** Haz clic en *Cambiar* y selecciona:
        *   Sistema operativo: **Ubuntu** (versión `22.04 LTS` o `24.04 LTS`).
        *   Tipo de disco: **Disco persistente estándar** (Standard Persistent Disk).
        *   Tamaño: **30 GB** (este es el tamaño máximo gratuito).
    *   **Firewall:** Marca *Permitir tráfico HTTP* y *Permitir tráfico HTTPS*.
4.  Haz clic en **Crear**.

#### 2. Instalar el Agente vía SSH
1.  En la lista de instancias de Compute Engine, haz clic en el botón **SSH** al lado de tu máquina virtual recién creada. Se abrirá una ventana de terminal en tu navegador.
2.  Clona este espacio de trabajo en el servidor o crea el script de instalación ejecutando:
    ```bash
    mkdir -p ~/hermes_workspace && cd ~/hermes_workspace
    ```
3.  Crea un archivo llamado `setup.sh`, pega el contenido de `scripts/setup_environment.sh` (que crearemos en este proyecto) y ejecútalo:
    ```bash
    nano setup.sh # Pega el script y guarda con Ctrl+O, Enter, Ctrl+X
    chmod +x setup.sh
    ./setup.sh
    ```
4.  Una vez termine la instalación de Python y Hermes, ejecuta la configuración:
    ```bash
    hermes setup
    ```
    *   Selecciona **OpenRouter** como proveedor.
    *   Ingresa tu API Key de OpenRouter.
    *   Establece el modelo por defecto en `nousresearch/hermes-3-llama-3.1-405b:free`.
5.  Configura el bot de Telegram:
    ```bash
    hermes gateway setup
    ```
    *   Elige **Telegram**.
    *   Introduce tu Bot Token y tu ID de usuario de Telegram.
6.  Activa el servicio Systemd para mantenerlo 24/7 (Ver **Paso 4**).

---

### MODO B: Oracle Cloud Always Free (Alto Rendimiento ARM)

Oracle Cloud ofrece el nivel gratuito más potente del mercado (24 GB de RAM), lo cual te permite hospedar un modelo local (como Ollama con Hermes 3 8B) sin depender de APIs externas.

#### 1. Configurar la VM ARM
1.  Crea una cuenta en [Oracle Cloud](https://www.oracle.com/cloud/free/).
2.  En el panel, ve a **Instancias de Compute** -> **Crear instancia**.
3.  Configura:
    *   **Imagen y forma:**
        *   Imagen: **Ubuntu 22.04** u **Oracle Linux**.
        *   Forma: Haz clic en *Editar* -> Elige **Ampere (ARM)** -> `VM.Standard.A1.Flex`. Asigna **2 o 4 OCPUs** y **12 o 24 GB de RAM**. (Esto califica como *Always Free*).
    *   **Redes:** Deja las opciones por defecto para crear una VCN pública.
    *   **Agregar claves SSH:** Descarga la clave privada provista (la necesitarás para conectarte desde tu PC).
    *   **Volumen de arranque:** Asigna entre **50 GB y 150 GB** (hasta 200 GB en total es gratis).
4.  Haz clic en **Crear**.

#### 2. Instalar Ollama y el Agente
Una vez que ingreses a tu VM ARM por SSH utilizando la clave descargada:
1.  Instala Ollama en tu servidor para correr modelos de forma local:
    ```bash
    curl -fsSL https://ollama.com/install.sh | sh
    ```
2.  Descarga el modelo Hermes 3 de 8B parámetros (ideal para la arquitectura ARM con 24GB de RAM):
    ```bash
    ollama run hermes3:8b
    ```
    *(Puedes salir de la prueba del modelo escribiendo `/bye`)*.
3.  Instala Hermes Agent con el instalador de terminal de Nous Research:
    ```bash
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    source ~/.bashrc
    ```
4.  Ejecuta `hermes setup` and selecciona **Ollama** como tu backend, apuntando a `http://localhost:11434`.
5.  Configura tu bot de Telegram de la misma manera que en el Modo A.

---

### MODO C: Hugging Face Spaces (Docker Serverless)

Si no deseas administrar servidores Linux (como VPS) ni usar terminales SSH, puedes hospedar el gateway en un contenedor Docker en Hugging Face Spaces de manera gratuita.

1.  Crea una cuenta en [Hugging Face](https://huggingface.co/).
2.  Haz clic en tu perfil -> **New Space**.
3.  Configura:
    *   **Space Name:** `mi-hermes-agent`
    *   **SDK:** Selecciona **Docker** -> **Blank**.
    *   **Space Hardware:** Selecciona **CPU Basic** (este es gratuito y se mantiene activo en segundo plano).
    *   **Visibility:** Recomiendo marcarlo como **Private** para proteger tus configuraciones de logs.
4.  Crea el Space.
5.  Ve a la pestaña **Settings** de tu Space. Desplázate hasta **Variables and secrets** y añade las siguientes como **Secrets**:
    *   `OPENROUTER_API_KEY`: Tu API Key de OpenRouter.
    *   `TELEGRAM_BOT_TOKEN`: Tu token de bot de Telegram.
    *   `TELEGRAM_USER_ID`: Tu ID numérico de Telegram.
6.  Sube el `Dockerfile` provisto en este espacio de trabajo a los archivos del Space. Hugging Face compilará automáticamente el agente y levantará el bot.

---

## Paso 4: Mantener el Bot 24/7 en segundo plano (Systemd)

Para los **Modos A y B**, si cierras la consola SSH, el agente dejará de responder. Sigue estos pasos para convertirlo en un servicio persistente del sistema operativo:

1.  Crea el archivo de servicio en tu servidor:
    ```bash
    sudo nano /etc/systemd/system/hermes.service
    ```
2.  Pega el contenido del archivo `scripts/hermes.service` (que hemos provisto en este workspace). Asegúrate de reemplazar `/home/ubuntu` por la ruta a tu carpeta de usuario si es diferente.
3.  Guarda el archivo (Ctrl+O, Enter, Ctrl+X).
4.  Recarga la configuración de servicios del sistema:
    ```bash
    sudo systemctl daemon-reload
    ```
5.  Habilita el servicio para que inicie automáticamente cuando se encienda el servidor y arráncalo inmediatamente:
    ```bash
    sudo systemctl enable --now hermes
    ```
6.  Verifica el estado del bot para comprobar que está corriendo correctamente:
    ```bash
    sudo systemctl status hermes
    ```

**¡Listo!** Ahora puedes abrir tu Telegram en tu móvil o PC, enviarle un mensaje a tu bot (`/start` o cualquier instrucción) y verás cómo Hermes Agent procesa y responde usando el modelo Hermes 3 405B en la nube de forma gratuita.
