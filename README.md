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



## использование с decker hub образца

затем уже ссылаемся на [репозиторий](https://hub.docker.com/repositories/ilyagall01)

[пример](https://github.com/IlyaGall/Docker-education/blob/main/product_service/docker-compose.yml)
