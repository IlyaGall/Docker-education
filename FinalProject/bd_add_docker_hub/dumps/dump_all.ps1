$containers = @(
    @{Name="Shop_bd_5001"; DB="ShopService"; Password="password1"; DumpFile="shop_dump.sql"},
    @{Name="Products_bd_5000"; DB="ProductsService"; Password="password2"; DumpFile="products_dump.sql"},
    @{Name="Favorite_bd_5002"; DB="FavoriteService"; Password="password3"; DumpFile="favorite_dump.sql"},
    @{Name="Comment_bd_5003"; DB="CommentService"; Password="password4"; DumpFile="comment_dump.sql"},
    @{Name="Cluster_bd_5004"; DB="ClusterService"; Password="password5"; DumpFile="cluster_dump.sql"}
)

foreach ($container in $containers) {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    docker exec $container.Name bash -c "PGPASSWORD=$($container.Password) pg_dump -U postgres -d $($container.DB) --encoding=utf-8" | Out-File -Encoding utf8 $container.DumpFile
    if (Test-Path $container.DumpFile -PathType Leaf) {
        $fileSize = (Get-Item $container.DumpFile).Length
        "Dump created: $($container.DumpFile) ($fileSize bytes)"
    }
}

"Dump process completed"