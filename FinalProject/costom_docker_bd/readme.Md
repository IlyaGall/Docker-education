

дамб в ручную через powershell и админа:


# Дамп ShopService (postgres1)
* ```docker-compose exec postgres1 pg_dump -U postgres -d ShopService > shop_dump.sql```

# Дамп ProductsService (postgres2)
* ```docker-compose exec postgres2 pg_dump -U postgres -d ProductsService > products_dump.sql```

# Дамп FavoriteService (postgres3)
* ```docker-compose exec postgres3 pg_dump -U postgres -d FavoriteService > favorite_dump.sql```

# Дамп CommentService (postgres4)
* ```docker-compose exec postgres4 pg_dump -U postgres -d CommentService > comment_dump.sql```

# Дамп ClusterService (postgres5)
* ```docker-compose exec postgres5 pg_dump -U postgres -d ClusterService > cluster_dump.sql```

# создание через автоматизированный скрипт

```powershell
$services = @("postgres1", "postgres2", "postgres3", "postgres4", "postgres5")
$dbs = @("ShopService", "ProductsService", "FavoriteService", "CommentService", "ClusterService")
$dump_names = @("shop_dump.sql", "products_dump.sql", "favorite_dump.sql", "comment_dump.sql", "cluster_dump.sql")

for ($i = 0; $i -lt 5; $i++) {
    docker-compose exec $services[$i] pg_dump -U postgres -d $dbs[$i] > $dump_names[$i]
    echo "Dump created: $($dump_names[$i])"
}

echo "All dumps created successfully"
```

* Сохранить файл, как dump_all.ps1, затем запустить в PowerShell



* По умолчанию PowerShell блокирует запуск скриптов. Разрешите выполнение ```Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force```
* затем перейти в папку где лежит скрипт с помощью команды ```C:\GitHub\Docker-education\FinalProject\costom_docker_bd```
* затем запустить файл ```.\dump_all.ps1```

########################################################## toot################3

## Подготовка структуры проекта

postgres-dumps/
├── Dockerfile
├── docker-compose.yml
├── init-db.sh
├── dumps/
│   ├── shop_dump.sql
│   ├── products_dump.sql
│   ├── favorite_dump.sql
│   ├── comment_dump.sql
│   └── cluster_dump.sql



### создание дамбов 

см в [создание через автоматизированный скрипт]() затем нужно положить их в папку dumps

### создание dockerfile

```dockerfile
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
```


### Создание init-db.sh

```init-db
#!/bin/bash

# Функция ожидания доступности БД
wait_for_db() {
  until pg_isready -h "$1" -p 5432 -U postgres; do
    echo "Ожидание $2..."
    sleep 5
  done
}

# Восстановление БД
restore_db() {
  local SERVICE=$1
  local DB_NAME=$2
  local DUMP_FILE=$3
  local PASSWORD=$4
  
  echo "Восстановление $DB_NAME из $DUMP_FILE"
  export PGPASSWORD=$PASSWORD
  psql -h $SERVICE -U postgres -c "CREATE DATABASE $DB_NAME;"
  psql -h $SERVICE -U postgres -d $DB_NAME -f /dumps/$DUMP_FILE
}

# Основной процесс
restore_db postgres1 ShopService shop.sql $PASSWORD1
restore_db postgres2 ProductsService products.sql $PASSWORD2
restore_db postgres3 FavoriteService favorite.sql $PASSWORD3
restore_db postgres4 CommentService comment.sql $PASSWORD4
restore_db postgres5 ClusterService cluster.sql $PASSWORD5

# Бесконечное ожидание
tail -f /dev/null
```

###  Сборка и публикация образа

1. Соберите Docker-образ:

```docker build -t yourusername/postgres-dumps:v1 .```

2. Авторизуйтесь в Docker Hub:

```docker login```

3. Загрузите образ в реестр:

```docker push yourusername/postgres-dumps:v1```





### чтобы отформатировать файлы dump

нужно запустить скрипт через gitbush, путём нажатие 2 раза на скрипт













# Для PowerShell (не все команды поддерживаются)
