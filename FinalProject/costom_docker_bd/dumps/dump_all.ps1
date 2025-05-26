$services = @("postgres1", "postgres2", "postgres3", "postgres4", "postgres5")
$dbs = @("ShopService", "ProductsService", "FavoriteService", "CommentService", "ClusterService")
$dump_names = @("shop_dump.sql", "products_dump.sql", "favorite_dump.sql", "comment_dump.sql", "cluster_dump.sql")

for ($i = 0; $i -lt 5; $i++) {
    docker-compose exec $services[$i] pg_dump -U postgres -d $dbs[$i] > $dump_names[$i]
    echo "Dump created: $($dump_names[$i])"
}

echo "All dumps created successfully"