#!/bin/bash
for file in dumps/*.sql; do
    sed -i '1s/^\xEF\xBB\xBF//' "$file"
    iconv -f UTF-8 -t UTF-8//IGNORE "$file" > "${file}.clean"
    mv "${file}.clean" "$file"
    echo "Обработан $file"
done