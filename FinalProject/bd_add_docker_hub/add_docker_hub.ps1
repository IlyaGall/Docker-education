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