# Удаляем пустые строки и строки с "-" в начале
for file in dumps/*.sql; do
    # Удаляем BOM маркер если есть
    sed -i '1s/^\xEF\xBB\xBF//' "$file"
    
    # Удаляем строки, содержащие только "-" и пустые строки
    sed -i '/^-\s*$/d' "$file"
    sed -i '/^\s*$/d' "$file"
    
    # Удаляем UTF-8 невалидные символы
    iconv -f UTF-8 -t UTF-8//IGNORE "$file" > "${file}.clean"
    mv "${file}.clean" "$file"
    
    echo "Очищен $file"
done