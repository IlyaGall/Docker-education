# Docker-education

Создание докер compose для бд на основе существующего postgresql

[пример](https://github.com/IlyaGall/Docker-education/blob/main/product_service/First%20docker/docker-compose.yml)

Сначала генерируем файл ```docker-compose.yml```


потом в power shell открываем, где он лежит ```cd -path C:\Users\Ilya\Desktop\docker```


затем запуск

```docker-compose up -d```

и получаем магию

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/1.JPG)

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/2.JPG)



## как переменовать

для этого нужно написать комадну

```docker tag <IMAGE_ID> <НОВОЕ_ИМЯ>:<ТЕГ>```

```docker tag 4836bc848e0d product-service:latest```


![img](https://github.com/IlyaGall/Docker-education/blob/main/img/3.JPG)

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/4.JPG)

!нужно переменовывать с логином инача ошибка

```docker tag 4836bc848e0d ilyagall01/product-service:latest```



## отправка на сервер docker hub образа

### создание репозитория

нужно создать репозиторий с именем, как выше

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/8.JPG)

### Загрузка образа

```docker login```

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/6.JPG)


```docker push ilyagall01/product-service:latest```

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/5.JPG)


### создание dump

!в docker-hub выгружаются данные таблиц с косяками, поэтому нужно создовать dump файлы.


с помощью скрипта в ручную



дамб в ручную через powershell и админа:


1. Дамп ShopService (postgres1)
* ```docker-compose exec postgres1 pg_dump -U postgres -d ShopService > shop_dump.sql```

2. Дамп ProductsService (postgres2)
* ```docker-compose exec postgres2 pg_dump -U postgres -d ProductsService > products_dump.sql```

3. Дамп FavoriteService (postgres3)
* ```docker-compose exec postgres3 pg_dump -U postgres -d FavoriteService > favorite_dump.sql```

4. Дамп CommentService (postgres4)
* ```docker-compose exec postgres4 pg_dump -U postgres -d CommentService > comment_dump.sql```

5. Дамп ClusterService (postgres5)
* ```docker-compose exec postgres5 pg_dump -U postgres -d ClusterService > cluster_dump.sql```

#### создание dumps через автоматизированный скрипт



файл скприта ```add_docker_hub.ps1``` представлен ниже, чтобы он работал рядом с ним нужно создать папку в проводнике под названием dumps
```
# Авторизация в Docker Hub
docker logout
docker login --username "ilyagall01"

# Параметры
$dockerHubRepo = "ilyagall01/product_bd"  # Единый репозиторий
$tagPrefix = "db-"  # Префикс для тегов

# Список контейнеров и их тегов
$containers = @(
    @{OriginalName="Products_bd_5000"; Tag="products"},
    @{OriginalName="Shop_bd_5001"; Tag="shop"},
    @{OriginalName="Favorite_bd_5002"; Tag="favorite"},
    @{OriginalName="Comment_bd_5003"; Tag="comment"},
    @{OriginalName="Cluster_bd_5004"; Tag="cluster"}
)

foreach ($container in $containers) {
    # Формируем полное имя образа с тегом
    $imageName = "$dockerHubRepo`:$($tagPrefix)$($container.Tag)"
    $imageName = $imageName.ToLower()  # Docker требует нижний регистр

    Write-Host "🔄 Обрабатываем контейнер $($container.OriginalName) -> $imageName"
    
    # Останавливаем контейнер для сохранения целостности данных
    docker stop $container.OriginalName
    
    # Создаем образ из контейнера
    docker commit $container.OriginalName $imageName
    
    # Запускаем контейнер обратно
    docker start $container.OriginalName
    
    # Пушим образ в Docker Hub
    Write-Host "⬆️ Загружаем образ в Docker Hub..."
    docker push $imageName
    
    Write-Host "✅ Успешно: $imageName"
}

Write-Host "🎉 Все образы загружены в репозиторий $dockerHubRepo!"
```
1. для запуска скрипта требуется перейти в папку, где лежит powershell. через ```cd -path путь_до_скрипта````
2. чтобы запустить скрипт нужно после перехода по пути в powershell набрать команду ```./название_файла.ps1```

## Импорт данных из docker hub и dumps

1. для запуска скрипта требуется перейти в папку, где лежит powershell. через ```cd -path путь_до_файла_docker_compose````
2. Нужно так же убедится, что рядом с файлом докер есть папка dumps, а в нутри лежет файлы
3. чтобы запустить скрипт нужно после перехода по пути в powershell набрать команду ```docker-compose up -d```


``` docker 
version: '3.8'

services:
  postgres1:
    image: ilyagall01/product-service2:latest1
    container_name: Products_bd_5000
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password2
      POSTGRES_DB: ProductsService
    ports:
      - "5000:5432"
    volumes:
      - postgres_data2:/var/lib/postgresql/data
      - ./dumps/products_dump.sql:/docker-entrypoint-initdb.d/products_init.sql

  postgres2:
    image: ilyagall01/product-service2:latest1
    container_name: Shop_bd_5001
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password1
      POSTGRES_DB: ShopService
    ports:
      - "5001:5432"
    volumes:
      - postgres_data1:/var/lib/postgresql/data
      - ./dumps/shop_dump.sql:/docker-entrypoint-initdb.d/shop_init.sql

  postgres3:
    image: ilyagall01/product-service2:latest1
    container_name: Favorite_bd_5002
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password3
      POSTGRES_DB: FavoriteService
    ports:
      - "5002:5432"
    volumes:
      - postgres_data3:/var/lib/postgresql/data
      - ./dumps/favorite_dump.sql:/docker-entrypoint-initdb.d/favorite_init.sql

  postgres4:
    image: ilyagall01/product-service2:latest1
    container_name: Comment_bd_5003
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password4
      POSTGRES_DB: CommentService
    ports:
      - "5003:5432"
    volumes:
      - postgres_data4:/var/lib/postgresql/data
      - ./dumps/comment_dump.sql:/docker-entrypoint-initdb.d/comment_init.sql

  postgres5:
    image: ilyagall01/product-service2:latest1
    container_name: Cluster_bd_5004
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password5
      POSTGRES_DB: ClusterService
    ports:
      - "5004:5432"
    volumes:
      - postgres_data5:/var/lib/postgresql/data
      - ./dumps/cluster_dump.sql:/docker-entrypoint-initdb.d/cluster_init.sql

volumes:
  postgres_data1:
  postgres_data2:
  postgres_data3:
  postgres_data4:
  postgres_data5:

```

затем уже ссылаемся на [репозиторий](https://hub.docker.com/repositories/ilyagall01)

[пример](https://github.com/IlyaGall/Docker-education/blob/main/product_service/docker-compose.yml)
