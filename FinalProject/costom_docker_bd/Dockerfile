FROM alpine:3.14

# Установка зависимостей
RUN apk add --no-cache \
    postgresql-client \
    bash \
    tzdata

# Создание рабочих директорий
RUN mkdir -p /dumps /scripts

# Копирование файлов
COPY dumps/*.sql /dumps/
COPY init-db.sh /scripts/
RUN chmod +x /scripts/init-db.sh

# Точка входа
CMD ["/scripts/init-db.sh"]