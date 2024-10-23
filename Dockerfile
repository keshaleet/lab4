FROM debian:latest

# Обновление и установка нужных пакетов
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx wget

# Очистка кеша apt
RUN apt-get clean

# Удаление содержимого /var/www/
RUN rm -rf /var/www/*

# Создание директорий
RUN mkdir -p /var/www/company.com/img

# Добавление index.html и img.jpg
COPY index.html /var/www/company.com/
COPY img.jpg /var/www/company.com/img/

# Настройка прав доступа
RUN chmod -R 755 /var/www/company.com

# Создание пользователя и группы
RUN useradd Nikita && \
    groupadd Bugaev && \
    usermod -a -G Bugaev Nikita

# Присваивание прав
RUN chown -R Nikita:Bugaev /var/www/company.com

# Замена пути в конфиге nginx
RUN sed -i 's|/var/www/html|/var/www/company.com|g' /etc/nginx/sites-enabled/default

# Поиск файла конфигурации пользователя nginx
RUN grep -rl 'user' /etc/nginx

# Изменение пользователя в файле конфигурации
RUN sed -i 's/user .*/user Nikita;/g' /etc/nginx/nginx.conf

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
