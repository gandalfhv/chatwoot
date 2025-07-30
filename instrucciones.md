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