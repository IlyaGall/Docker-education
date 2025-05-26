#!/bin/bash

restore_db() {
  local SERVICE=$1
  local DB_NAME=$2
  local DUMP_FILE=$3
  local PASSWORD=$4
  
  echo "Обработка $DB_NAME ($DUMP_FILE)"
  
  # Проверка файла
  if [ ! -f "/dumps/$DUMP_FILE" ]; then
    echo "Файл /dumps/$DUMP_FILE не найден!"
    return 1
  fi

  # Удаление старой БД (если существует)
  if PGPASSWORD=$PASSWORD psql -h $SERVICE -U postgres -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "Удаление старой БД $DB_NAME..."
    PGPASSWORD=$PASSWORD psql -h $SERVICE -U postgres -c "DROP DATABASE $DB_NAME;"
  fi

  # Создание новой БД
  echo "Создание БД $DB_NAME..."
  PGPASSWORD=$PASSWORD psql -h $SERVICE -U postgres -c "CREATE DATABASE $DB_NAME ENCODING 'UTF8' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;"

  # Восстановление с обработкой ошибок
  echo "Восстановление из /dumps/$DUMP_FILE"
  if ! PGPASSWORD=$PASSWORD psql -h $SERVICE -U postgres -d $DB_NAME -v ON_ERROR_STOP=1 -f "/dumps/$DUMP_FILE"; then
    echo "Ошибка восстановления $DB_NAME"
    return 1
  fi

  echo "Успешно восстановлено $DB_NAME"
}

# Даем время PostgreSQL запуститься
sleep 10

# Восстанавливаем БД с обработкой ошибок для каждой
restore_db postgres1 ShopService shop.sql $PASSWORD1
restore_db postgres2 ProductsService products.sql $PASSWORD2
restore_db postgres3 FavoriteService favorite.sql $PASSWORD3
restore_db postgres4 CommentService comment.sql $PASSWORD4
restore_db postgres5 ClusterService cluster.sql $PASSWORD5

echo "Процесс завершен"
tail -f /dev/null