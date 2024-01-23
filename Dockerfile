FROM centos:7
# Establecer la zona horaria
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone
# Instalar EPEL y Remi repository
RUN yum -y install epel-release yum-utils
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# Habilitar el repositorio PHP 7.3
RUN yum-config-manager --enable remi-php73
RUN yum -y install zip unzip
# Instalar PHP 7.3 y extensiones comunes
RUN yum -y install php php-mysqlnd php-pdo php-gd php-mbstring php-zip php-xml php-imap php-curl simplexml
# Instalar Apache
RUN yum -y install httpd mod_ssl
# Crear directorios para los logs de Apache y asignar permisos
RUN mkdir -p /var/log/httpd && \
    chmod -R 755 /var/log/httpd && \
    chown -R apache:apache /var/log/httpd

# RUN a2enmod rewrite
RUN pwd
ENV APACHE_DOCUMENT_ROOT /var/www/html/

# Configurar Apache
RUN echo "ServerName localhost" >>/etc/httpd/conf/httpd.conf
# Copy config files
COPY /server/php.ini /usr/local/etc/php/php.ini
COPY /server/virtualhost.conf /etc/httpd/conf.d/my_virtualhost.conf
# Copia los archivos de certificado y clave al contenedor
COPY server/mycert.crt /etc/ssl/certs/
COPY server/mycert.key /etc/ssl/private/
# Habilita los módulos en la configuración de Apache
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/httpd/conf.modules.d/00-base.conf && \
    sed -i '/LoadModule ssl_module/s/^#//g' /etc/httpd/conf.modules.d/00-ssl.conf

# Configurar el directorio de trabajo
WORKDIR /var/www/html
# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache en el arranque del contenedor
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]


## Generate ssl certs 
## Genera una clave privada de 2048 bits (puedes ajustar la longitud según tus necesidades)
#$ openssl genpkey -algorithm RSA -out mycert.key -aes256

## Genera una solicitud de certificado (CSR)
#$ openssl req -new -key mycert.key -out mycert.csr

# Genera un certificado autofirmado válido por 365 días
#$ openssl x509 -req -days 365 -in mycert.csr -signkey mycert.key -out mycert.crt
