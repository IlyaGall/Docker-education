# Авторизация в Docker Hub
docker login

# Параметры (замените на свои реальные данные)
$dockerHubUsername = "ilyagall01"  # Ваш логин Docker Hub
$repositoryPrefix = "product-bd-"  # Префикс репозиториев (должен быть в lowercase)
$tag = "latest"

# Список контейнеров
$containers = @(
    @{OriginalName="Products_bd_5000"; DbName="products"},
    @{OriginalName="Shop_bd_5001"; DbName="shop"},
    @{OriginalName="Favorite_bd_5002"; DbName="favorite"},
    @{OriginalName="Comment_bd_5003"; DbName="comment"},
    @{OriginalName="Cluster_bd_5004"; DbName="cluster"}
)

foreach ($container in $containers) {
    # Формируем полное имя образа (все символы должны быть в нижнем регистре)
    $imageName = "$dockerHubUsername/$($repositoryPrefix)$($container.DbName):$tag".ToLower()
    
    Write-Host "Обрабатываем контейнер $($container.OriginalName) -> $imageName"
    
    # Останавливаем контейнер для сохранения целостности
    docker stop $container.OriginalName
    
    # Создаем образ из контейнера
    docker commit $container.OriginalName $imageName
    
    # Запускаем контейнер обратно
    docker start $container.OriginalName
    
    # Пушим образ в Docker Hub
    docker push $imageName
    
    Write-Host "Образ успешно загружен: $imageName"
}

Write-Host "Все образы успешно выгружены в Docker Hub"