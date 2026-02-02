la marca se configura con esta instruccion en progress

docker exec chatwoot_rails_1 bundle exec rails r "InstallationConfig.find_by(name: 'BRAND_NAME').update(value: 'MultiAgente MibOT'); InstallationConfig.find_by(name: 'BRAND_URL').update(value: 'https://www.prograpps.com'); InstallationConfig.find_by(name: 'WIDGET_BRAND_URL').update(value: 'https://www.prograpps.com/multiagente'); InstallationConfig.find_by(name: 'TERMS_URL').update(value: 'https://www.prograpps.com/termsmultiagente'); InstallationConfig.find_by(name: 'PRIVACY_URL').update(value: 'https://www.prograpps.com/privacymultiagente')"

Generar imagen y subir
docker build -t edwherrera160/multiagente-mibot:1.4 -f docker/Dockerfile .
docker push edwherrera160/multiagente-mibot:1.4


Resumen del PlanNuestro objetivo es crear una versión personalizada de Chatwoot. 

La estrategia combina modificaciones en el código fuente (que vivirán en nuestro fork) y una configuración inicial en la base de datos (que será persistente).

Parte 1: Cambios en el Código Fuente (Nuestra "Capa de Personalización")Estos son todos los archivos que hemos modificado o creado en nuestro proyecto en Windows. Asegúrate de que todos estos cambios estén guardados y confirmados en un commit.

Ocultar el Botón de Filtro para Agentes:
Archivo: app/javascript/dashboard/components/ChatListHeader.vueCambio: Usar el composable useAdmin() para añadir una condición v-if="isAdmin" al botón del filtro.

Cambiar el Título de la Pestaña del Navegador:Archivo: app/views/layouts/vueapp.html.erbCambio (Tu Solución): Modificar la etiqueta <title> para que use la variable BRAND_NAME en lugar de INSTALLATION_NAME.

Traducir y Personalizar Plantillas de Correo:
Archivos:app/views/devise/mailer/confirmation_instructions.html.erb
app/views/devise/mailer/password_change.html.erb
app/views/devise/mailer/reset_password_instructions.html.erb
app/views/devise/mailer/unlock_instructions.html.erb

Cambio: Reemplazar el contenido en inglés por las versiones traducidas al español.
Corregir Finales de Línea (La Base Técnica):Archivo: .gitattributes (creado en la raíz del proyecto).Cambio: Asegurar que todos los archivos de texto usen finales de línea de Linux (LF) para evitar errores en Docker.

Parte 2: Cambios en la Base de Datos (Configuración Inicial)Esta es una operación que haremos una sola vez después de desplegar nuestra nueva imagen.Objetivo: Actualizar los valores de configuración de la marca en la base de datos de PostgreSQL.
Método: Usaremos el comando docker exec ... rails r ... para que la propia aplicación de Chatwoot realice los cambios de forma segura.

Para entrar a la BD 
    docker exec -it chatwoot_postgres_1 psql -U postgres -d chatwoot_production
Verificar los valores 
    SELECT name, serialized_value FROM installation_configs
WHERE name IN ('BRAND_NAME', 'BRAND_URL', 'WIDGET_BRAND_URL', 'TERMS_URL', 'PRIVACY_URL');

docker exec chatwoot_rails_1 bundle exec rails r "InstallationConfig.find_by(name: 'BRAND_NAME').update(value: 'MultiAgente MibOT'); InstallationConfig.find_by(name: 'BRAND_URL').update(value: 'https://prograpps.com/multiagente'); InstallationConfig.find_by(name: 'WIDGET_BRAND_URL').update(value: 'https://prograpps.com'); InstallationConfig.find_by(name: 'TERMS_URL').update(value: 'https://prograpps.com/multiagente/terminos-servicio'); InstallationConfig.find_by(name: 'PRIVACY_URL').update(value: 'https://prograpps.com/multiagente/politica-privacidad')"

Valores a Cambiar:BRAND_NAME, BRAND_URL, WIDGET_BRAND_URL, TERMS_URL, PRIVACY_URL

Parte 3: El Flujo de DespliegueEste es el proceso completo para llevar nuestros cambios a producción.
En tu PC con Windows:
    Confirmar Cambios: Asegúrate de que todos los cambios de la Parte 1 estén guardados en un commit (git commit -am "Final customizations").
    Subir Código: Sube tus commits a tu fork en GitHub (git push).

Construir Imagen: Crea la imagen de Docker con una nueva versión 

    docker build -t edwherrera160/multiagente-mibot:1.X -f docker/Dockerfile .

Subir Imagen: Sube la nueva imagen a Docker Hub 

    docker push edwherrera160/multiagente-mibot:1.4

En tu Servidor VPS:Actualizar Configuración: Edita el archivo docker-compose.yml y cambia la etiqueta de la imagen a la nueva versión (1.X).
    nano docker-compose.yml
Redesplegar: Ejecuta docker-compose down && docker-compose up -d

Actualizar Base de Datos: Ejecuta el comando docker exec ... rails r ... para aplicar la configuración de la Parte 2.Este plan es sólido, completo y sigue las mejores prácticas. Has hecho un trabajo de análisis excepcional para llegar a esta solución final.





Escenario:Estás en una nueva PC con Windows. Quieres instalar tu versión personalizada de Chatwoot en un servidor nuevo con Ubuntu.Fase 1: Preparar tu Nueva PC con Windows
En tu nueva computadora, solo necesitas instalar tres herramientas. No necesitas instalar Ruby ni Vue.js.
Git for Windows: Es el sistema de control de versiones. Te permite descargar el código desde GitHub.Descarga: https://git-scm.com/
Instalación: Durante la instalación, acepta las opciones por defecto. Asegúrate de que instale "Git Bash".Docker Desktop: Es la herramienta que construye y gestiona los contenedores de tu aplicación.Descarga: https://www.docker.com/products/docker-desktop/Instalación: Sigue las instrucciones. Probablemente te pedirá reiniciar la PC. Después de reiniciar, asegúrate de que el icono de la ballena de Docker aparezca en tu barra de tareas.Visual Studio Code (Opcional, pero recomendado): El mejor editor para ver y modificar el código.Descarga: https://code.visualstudio.com/Fase 2: Descargar tu Código Personalizado desde GitHubAhora vamos a traer el código de tu versión personalizada desde tu repositorio en GitHub a tu PC.Abre "Git Bash" desde el menú de inicio.Navega a una carpeta donde quieras guardar tus proyectos.# Ejemplo: crear una carpeta 'proyectos' en tu usuario
mkdir -p C:/Datos/Proyectos
cd C:/Datos/Proyectos
Clona tu repositorio: Este comando descarga tu proyecto. git clone https://github.com/gandalfhv/chatwoot.git
Entra en la carpeta del proyecto:cd Chatwoot
Cámbiate a tu rama de personalización: Este es el paso más importante. Le dice a Git que quieres trabajar con la versión que tiene todos tus cambios.git checkout feature/ocultar-filtro-agentes
Fase 3: Construir la Imagen de Docker (El Paquete)Ahora vamos a empaquetar tu código en una "imagen" lista para ser usada.Asegúrate de que Docker Desktop esté en ejecución.Desde la terminal Git Bash, dentro de la carpeta chatwoot, ejecuta este comando. Reemplaza edwherrera160 por tu usuario de Docker Hub.docker build -t edwherrera160/multiagente-mibot:2.0 -f docker/Dockerfile .
(Nota: He usado la versión 2.0. Puedes cambiarla si quieres).Este proceso tardará varios minutos.Fase 4: Subir la Imagen a Docker Hub (La Distribución)Vamos a subir tu paquete a la nube para que tu servidor pueda descargarlo.Inicia sesión en Docker Hub:docker login -u edwherrera160
Te pedirá tu contraseña.Sube la imagen:docker push edwherrera160/multiagente-mibot:2.0
Fase 5: Desplegar en el ServidorAhora, conéctate a tu servidor VPS con Ubuntu y pon todo en marcha.Conéctate por SSH a tu servidor.Ve a la carpeta de Chatwoot (normalmente /opt/chatwoot).Edita el archivo docker-compose.yml con nano docker-compose.yml.Busca la línea image: del servicio chatwoot o app y modifícala para que apunte a tu nueva imagen:image: edwherrera160/multiagente-mibot:2.0
Guarda y cierra el archivo (Ctrl+X, Y, Enter).Levanta los servicios:docker-compose down && docker-compose up -d
Fase 6: Configuración Final de la Marca (La "Llave Maestra")Este es un paso que solo necesitas hacer una vez en una instalación nueva para configurar la marca en la base de datos.Ejecuta este único comando en tu servidor:docker exec chatwoot_rails_1 bundle exec rails r "InstallationConfig.find_by(name: 'BRAND_NAME').update(value: 'Multiagente MibOT'); InstallationConfig.find_by(name: 'BRAND_URL').update(value: 'https://www.prograpps.com'); InstallationConfig.find_by(name: 'WIDGET_BRAND_URL').update(value: 'https://www.prograpps.com'); InstallationConfig.find_by(name: 'TERMS_URL').update(value: 'https://www.prograpps.com/terms'); InstallationConfig.find_by(name: 'PRIVACY_URL').update(value: 'https://www.prograpps.com/privacy')"
Para que los cambios se apliquen, haz un último reinicio:docker-compose restart
¡Listo! Ahora tu versión personalizada de Chatwoot debería estar funcionando perfectamente en tu servidor.




# Procedimiento de Actualización de Branding y Traducciones (Chatwoot v4.10.1)

### 1. Fase de Desarrollo (PC Local / VS Code)

**B. Empaquetado y Subida:**
Ejecutar en terminal de Visual Studio Code:

  o powershell
# 1. Guardar cambios
git add .
git commit -m "Update: Ajustes de marca y traducciones"

# 2. Compilar Imagen (Sobrescribiendo la v4.10.1)
docker build -t edwherrera160/multiagente-mibot:4.10.1 -f docker/Dockerfile .

# 3. Subir a Docker Hub
docker push edwherrera160/multiagente-mibot:4.10.1


### Fase de Despliegue (Servidor VPS / Producción)
# 1. Descargar la actualización (Solo baja las capas nuevas)
docker compose pull

# 2. Aplicar cambios (Reinicio quirúrgico: Solo recrea lo que cambió)
docker compose up -d

# 3. Limpieza (Eliminar la imagen vieja que quedó huérfana)
docker image prune -f