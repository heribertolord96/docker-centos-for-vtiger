# Use an official PHP 7.3 image as your base image
# FROM php:7.3-apache
FROM centos:7

# Instalar PHP y extensiones comunes
# RUN yum -y install httpd php php-mysql php-gd php-xml
# RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# RUN docker-php-ext-install pdo && docker-php-ext-enable pdo
# RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
# RUN docker-php-ext-install pdo && docker-php-ext-enable pdo

# Instalar EPEL y Remi repository
RUN yum -y install epel-release yum-utils
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# Habilitar el repositorio PHP 7.3
RUN yum-config-manager --enable remi-php73
RUN yum -y install zip unzip
# Instalar PHP 7.3 y extensiones comunes
RUN yum -y install php php-mysqlnd php-pdo php-gd php-mbstring php-zip php-xml php-imap php-curl simplexml
#yum install -y php-imap php-curl php-xml
# Instalar Apache
RUN yum -y install httpd

# Crear directorios para los logs de Apache y asignar permisos
RUN mkdir -p /var/log/httpd && \
    chmod -R 755 /var/log/httpd && \
    chown -R apache:apache /var/log/httpd

# RUN a2enmod rewrite
RUN pwd
ENV APACHE_DOCUMENT_ROOT /var/www/html/

# Configurar Apache
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

# RUN chown -R www-data:www-data .
# Your recommended PHP settings (adjust php.ini as needed)
# RUN echo "file_uploads = on" >> /usr/local/etc/php/php.ini && \
#     echo "upload_max_filesize = 128M" >> /usr/local/etc/php/php.ini && \
#     echo "display_errors = on" >> /usr/local/etc/php/php.ini && \
#     echo "sql.safe_mode = off" >> /usr/local/etc/php/php.ini && \
#     echo "max_input_vars = 10000" >> /usr/local/etc/php/php.ini && \
#     echo "max_execution_time = 600" >> /usr/local/etc/php/php.ini && \
#     echo "memory_limit = 512M" >> /usr/local/etc/php/php.ini && \
#     echo "post_max_size = 128M" >> /usr/local/etc/php/php.ini && \
#     echo "max_input_time = 120" >> /usr/local/etc/php/php.ini && \
#     echo "register_globals = Off" >> /usr/local/etc/php/php.ini && \
#     echo "output_buffering = On" >> /usr/local/etc/php/php.ini && \
#     echo "error_reporting = E_WARNING & ~E_NOTICE" >> /usr/local/etc/php/php.ini && \
#     echo "allow_call_time_reference = On" >> /usr/local/etc/php/php.ini && \
#     echo "short_open_tag = On" >> /usr/local/etc/php/php.ini && \
#     echo "suhosin.simulation = on" >> /usr/local/etc/php/php.ini


COPY /server/php.ini /usr/local/etc/php/php.ini
COPY /server/virtualhost.conf /etc/httpd/conf.d/my_virtualhost.conf
WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Exponer el puerto 80
EXPOSE 80

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Iniciar Apache en el arranque del contenedor
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

###########################################

# # # # Install required PHP extensions
# # # RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
# # # # RUN docker-php-ext-install mbstring && docker-php-ext-enable mbstring
# # # RUN docker-php-ext-install pdo && docker-php-ext-enable pdo

# # # # Enable Apache rewrite module
# # # RUN a2enmod rewrite

# # # RUN pwd
# # # ENV APACHE_DOCUMENT_ROOT /var/www/html/public
# # # # Copy your Vtiger CRM project files to the container
# # # # ADD vtigercrm/. /var/www/html/

# # # # Set correct file permissions as per your article recommendations
# # # # Note: You may need to adjust these permissions based on your Vtiger version
# # # RUN chown -R www-data:www-data .


# # # # Your recommended PHP settings (adjust php.ini as needed)
# # # RUN echo "file_uploads = on" >> /usr/local/etc/php/php.ini && \
# # #     echo "upload_max_filesize = 128M" >> /usr/local/etc/php/php.ini && \
# # #     echo "display_errors = on" >> /usr/local/etc/php/php.ini && \
# # #     echo "sql.safe_mode = off" >> /usr/local/etc/php/php.ini && \
# # #     echo "max_input_vars = 10000" >> /usr/local/etc/php/php.ini && \
# # #     echo "max_execution_time = 600" >> /usr/local/etc/php/php.ini && \
# # #     echo "memory_limit = 512M" >> /usr/local/etc/php/php.ini && \
# # #     echo "post_max_size = 128M" >> /usr/local/etc/php/php.ini && \
# # #     echo "max_input_time = 120" >> /usr/local/etc/php/php.ini && \
# # #     echo "register_globals = Off" >> /usr/local/etc/php/php.ini && \
# # #     echo "output_buffering = On" >> /usr/local/etc/php/php.ini && \
# # #     echo "error_reporting = E_WARNING & ~E_NOTICE" >> /usr/local/etc/php/php.ini && \
# # #     echo "allow_call_time_reference = On" >> /usr/local/etc/php/php.ini && \
# # #     echo "short_open_tag = On" >> /usr/local/etc/php/php.ini && \
# # #     echo "suhosin.simulation = on" >> /usr/local/etc/php/php.ini


# # # # RUN chmod -R 777 /var/www/html
# # # # Expose port 80 for Apache
# # # # EXPOSE 80
# # # # Set the working directory
# # # WORKDIR /var/www/html

# # # ENV DEBIAN_FRONTEND noninteractive
# # # ENV TZ=UTC

# # # RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Start the Apache web server
# CMD ["apache2-foreground"]
