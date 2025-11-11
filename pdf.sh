#!/bin/bash

# Archivo de salida temporal
OUT="combinado.md"
> "$OUT"  # vaciar archivo si existía

# 1️⃣ Añadir el README.md del directorio raíz
if [ -f "./README.md" ]; then
    echo "# README del directorio raíz" >> "$OUT"
    cat "./README.md" >> "$OUT"
    echo -e "\n\n" >> "$OUT"
fi

# 2️⃣ Añadir los README.md de subdirectorios en orden jerárquico
# find recorre los subdirectorios, ordenados
find . -mindepth 2 -type f -name "README.md" | sort | while read file; do
    echo "# README de $file" >> "$OUT"
    cat "$file" >> "$OUT"
    echo -e "\n\n" >> "$OUT"
done

echo "Archivo combinado creado en $OUT"

# 3️⃣ Convertir a PDF con Pandoc
pandoc "$OUT" -o salida.pdf --pdf-engine=xelatex --toc -V geometry:margin=2cm -V fontsize=12pt

echo "PDF generado en salida.pdf"
