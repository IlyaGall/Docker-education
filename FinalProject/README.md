# Docker-education

Создание докер compose для бд на основе существующего postgresql c помощью ```docker-compose.yml```. Нужно создать файл в директории windows.


[пример github](https://github.com/IlyaGall/Docker-education/blob/main/FinalProject/base_docker_bd/docker-compose.yml)

код примера:

```docker-compose
version: '3.8'

services:
  postgres1:
    image: postgres:14
    container_name: ShopService_5001
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password1
      POSTGRES_DB: ShopService
    ports:
      - "5001:5432"  # Первая БД на стандартном порту # нельзя на стандартном порту
    volumes:
      - postgres_data1:/var/lib/postgresql/data

  postgres2:
    image: postgres:14
    container_name: ProductsService_5000
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password2
      POSTGRES_DB: ProductsService
    ports:
      - "5000:5432"  # Вторая БД на порту 5000
    volumes:
      - postgres_data2:/var/lib/postgresql/data

  postgres3:
    image: postgres:14
    container_name: FavoriteService_5002
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password3
      POSTGRES_DB: FavoriteService
    ports:
      - "5002:5432"  # Третья БД на порту 5002
    volumes:
      - postgres_data3:/var/lib/postgresql/data

  postgres4:
    image: postgres:14
    container_name: CommentService_5003
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password4
      POSTGRES_DB: CommentService
    ports:
      - "5003:5432"  # Четвертая БД на порту 5435
    volumes:
      - postgres_data4:/var/lib/postgresql/data

  postgres5:
    image: postgres:14
    container_name: ClusterService_5004
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password5
      POSTGRES_DB: ClusterService
    ports:
      - "5004:5432"  # Пятая БД на порту 5436
    volumes:
      - postgres_data5:/var/lib/postgresql/data

volumes:
  postgres_data1:
  postgres_data2:
  postgres_data3:
  postgres_data4:
  postgres_data5:
```

Для запуска скрипта нужно:
* Powershell открыть директорию, где он лежит, например, ```cd -path C:\Users\Ilya\Desktop\docker```
* после перехода по пути нужно, выполнить скрипт ```docker-compose up -d```
* затем получим следующую картину (рисунок 1 и рисунок 2):

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/1.JPG)

рисуник 1. Скачивание и установка images с контенерами

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/2.JPG)

рисунок 2. screenshoot docker desktop с развернутым images

## Переменование Images в нутри docker desktop

В связи с тем, что базовый images(образ) нельзя в зашрузить(push) docker-hub для этого нужно написать комадну, которая переменует images

* ```docker tag <IMAGE_ID> <НОВОЕ_ИМЯ>:<ТЕГ>``` - пример 1, в не рамках системы
* ```docker tag 4836bc848e0d product-service:latest```- пример 2 в powershell, важно отметить, то что нажимать на иконку копировать в виде квадратиков не стоит, он копирует полное имя, которое после копирования не сработает, поэтому нужно копировать имя с помощью выделения и сочения клавиш ctr+c

На рисунках 3 и 4 отображён процесс копирования:

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/3.JPG)

рисунок 3. До переменовывания

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/4.JPG)

рисунок 4. После переменыновыния images 

ТАк же нужно отметить, что переменовывать нужно на такое же название, как и в созданном репозитирии+nickname, в противном случае будет ошибка, например, вот так: ```docker tag 4836bc848e0d ilyagall01/product-service:latest``` 

## отправка на сервер docker hub образа

### создание репозитория

нужно создать репозиторий с именем, как в предыдущем пункте, например, такое ```ilyagall01/product-service```, на рисунке 5 показан репозиторий в docker-hub, который совпадает с названием images, локальным в docker desktop

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/8.JPG)

рисунок 5. Docker -hub

### Загрузка образа

Для того чтобы загрузить образ в docker-hub, нужно в powerShell авторизироваться ```docker login```, как показано на рисунке 6.

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/6.JPG)

рисунок 6.

Команда в powershell ```docker push ilyagall01/product-service:latest``` позволяет выгрузить образ в docker репозиторий, важно отметить, что ```:latest``` означает тег в репозитории. На рисунке 7, отображён screenshoot процесс импорта данных из docker-destop в docker hub.

![img](https://github.com/IlyaGall/Docker-education/blob/main/img/5.JPG)

рисунок 7. 


### создание dump


К сожелению  в в docker-hub выгружаются таблицы и данные не корретно, поэтому требуется создать dump файлы бд. Для этого можно воспользоваться 2 способами, представленными ниже:
1. С помощью команд, командны нужно перменять для каждого контенра по отдельности, что бывает трудоёмким . Для выполнения комнады требуется в войти в powershell и вызвать команды для каждого контенера по отдельности:

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
