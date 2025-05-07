#!/bin/bash

# Script para gestionar archivos .promt.md y subirlos a un repositorio específico
# Autor: Juan José R. G.

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando proceso de actualización de archivos .promt.md${NC}"

# 1. Eliminar el directorio .git y .gitignore en la carpeta actual (solo en el directorio raíz)
if [ -d ".git" ]; then
    echo -e "${YELLOW}Eliminando directorio .git existente en el directorio raíz...${NC}"
    rm -rf .git
    echo -e "${GREEN}Directorio .git eliminado correctamente.${NC}"
else
    echo -e "${YELLOW}No se encontró directorio .git en la carpeta actual.${NC}"
fi

# Eliminar .gitignore si existe
if [ -f ".gitignore" ]; then
    echo -e "${YELLOW}Eliminando archivo .gitignore existente...${NC}"
    rm -f .gitignore
    echo -e "${GREEN}Archivo .gitignore eliminado correctamente.${NC}"
fi

# 2. Inicializar un nuevo repositorio Git
echo -e "${YELLOW}Inicializando nuevo repositorio Git...${NC}"
git init
echo -e "${GREEN}Repositorio Git inicializado.${NC}"

# 3. Crear un .gitignore intermedio para excluir directorios .git y archivos .gitignore de subcarpetas
echo -e "${YELLOW}Creando .gitignore intermedio para excluir subcarpetas con repositorios...${NC}"
cat > .gitignore << 'EOL'
# Ignorar todo por defecto
*

# No ignorar archivos .promt.md en ningún nivel
!*.promt.md
!*/*.promt.md
!*/*/*.promt.md
!*/*/*/*.promt.md
!*/*/*/*/*.promt.md
!*/*/*/*/*/*.promt.md
!*/*/*/*/*/*/*.promt.md

# Ignorar directorios .git y archivos .gitignore en subcarpetas
**/.git/
**/.gitignore

# No ignorar este script
!update_promts.sh
EOL
echo -e "${GREEN}.gitignore intermedio creado correctamente.${NC}"

# 4. Buscar todos los archivos .promt.md de manera recursiva
echo -e "${YELLOW}Buscando archivos .promt.md de manera recursiva...${NC}"

# Buscar todos los archivos .promt.md en todo el árbol de directorios
echo -e "${YELLOW}Buscando todos los archivos .promt.md en el sistema de archivos...${NC}"
ALL_PROMT_FILES=$(find . -name "*.promt.md" -type f | sort)

if [ -z "$ALL_PROMT_FILES" ]; then
    echo -e "${RED}No se encontraron archivos .promt.md${NC}"
    exit 1
fi

echo -e "${GREEN}Se encontraron los siguientes archivos .promt.md:${NC}"
echo "$ALL_PROMT_FILES"
echo -e "Total: $(echo "$ALL_PROMT_FILES" | wc -l) archivos"

# 5. Agregar archivos .promt.md al repositorio
echo -e "${YELLOW}Agregando archivos .promt.md al repositorio...${NC}"

# Agregar cada archivo individualmente para asegurar que todos sean incluidos
for file in $ALL_PROMT_FILES; do
    echo -e "  Agregando: ${file}"
    # Usar -f para forzar la adición incluso si el archivo está en .gitignore
    # Usar --ignore-errors para continuar si hay errores (como archivos en subdirectorios .git)
    git add -f --ignore-errors "${file}" 2>/dev/null || echo -e "  ${RED}No se pudo agregar: ${file}${NC}"
done

# Verificar qué archivos se agregaron realmente
echo -e "${YELLOW}Verificando archivos .promt.md agregados...${NC}"
ADDED_FILES=$(git ls-files "*.promt.md" | sort)
echo -e "${GREEN}Archivos .promt.md agregados al índice de Git:${NC}"
echo "$ADDED_FILES"
echo -e "Total agregados: $(echo "$ADDED_FILES" | wc -l) archivos"

# Verificar si hay archivos que no se pudieron agregar
NOT_ADDED=$(comm -23 <(echo "$ALL_PROMT_FILES" | sed 's/^\.\///') <(echo "$ADDED_FILES"))
if [ ! -z "$NOT_ADDED" ]; then
    echo -e "${RED}Archivos .promt.md que no se pudieron agregar:${NC}"
    echo "$NOT_ADDED"
    echo -e "${YELLOW}Intentando agregar estos archivos nuevamente con método alternativo...${NC}"

    # Crear un archivo de contenido para cada archivo no agregado
    echo "$NOT_ADDED" | while read file; do
        if [ -f "./$file" ]; then
            # Obtener el contenido del archivo
            content=$(cat "./$file")
            filename=$(basename "$file")
            dir_path=$(dirname "$file")

            # Crear un archivo con el mismo nombre en el directorio raíz
            alt_filename="${dir_path//\//_}_${filename}"
            echo -e "  Creando archivo alternativo: ${alt_filename}"
            echo "# Contenido original de: $file" > "$alt_filename"
            echo "# Creado automáticamente por update_promts.sh" >> "$alt_filename"
            echo "# $(date '+%Y-%m-%d %H:%M:%S')" >> "$alt_filename"
            echo "" >> "$alt_filename"
            echo "$content" >> "$alt_filename"

            # Agregar el archivo alternativo
            git add -f "$alt_filename" 2>/dev/null && echo -e "  ${GREEN}Agregado archivo alternativo: ${alt_filename}${NC}"
        fi
    done
fi

echo -e "${GREEN}Archivos .promt.md agregados correctamente.${NC}"

# 6. Realizar primer commit solo con los archivos .promt.md
echo -e "${YELLOW}Realizando commit de archivos .promt.md...${NC}"
git commit -m "Actualización de archivos .promt.md - $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${GREEN}Commit de archivos .promt.md realizado.${NC}"

# 7. Configurar repositorio remoto
echo -e "${YELLOW}Configurando repositorio remoto...${NC}"
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:jaun-rg/personal-promts.git
echo -e "${GREEN}Repositorio remoto configurado.${NC}"

# 8. Subir archivos .promt.md al repositorio remoto
echo -e "${YELLOW}Subiendo archivos .promt.md al repositorio remoto de forma forzada a la rama main...${NC}"
git push -f --set-upstream origin main
echo -e "${GREEN}Archivos .promt.md subidos correctamente de forma forzada a la rama main.${NC}"

# 9. Crear archivo .gitignore final DESPUÉS de subir los archivos .promt.md al repositorio
echo -e "${YELLOW}Creando archivo .gitignore final...${NC}"
cat > .gitignore << 'EOL'
# Ignorar todo por defecto
*

# No ignorar archivos .promt.md en ningún nivel
!*.promt.md
!*/*.promt.md
!*/*/*.promt.md
!*/*/*/*.promt.md
!*/*/*/*/*.promt.md
!*/*/*/*/*/*.promt.md
!*/*/*/*/*/*/*.promt.md

# No ignorar estos archivos
!.gitignore
!update_promts.sh

# Ignorar directorios .git y archivos .gitignore en subcarpetas
**/.git/
**/.gitignore
EOL
echo -e "${GREEN}Archivo .gitignore final creado correctamente.${NC}"

# 10. Agregar .gitignore y el script
echo -e "${YELLOW}Agregando .gitignore y script al repositorio...${NC}"
git add --force .gitignore update_promts.sh
echo -e "${GREEN}Archivos adicionales agregados correctamente.${NC}"

# 11. Verificar qué archivos se han agregado
echo -e "${YELLOW}Verificando archivos agregados al repositorio...${NC}"
git status -s
echo -e "${GREEN}Verificación completada.${NC}"

# 12. Realizar segundo commit con .gitignore y script
echo -e "${YELLOW}Realizando commit de archivos adicionales...${NC}"
git commit -m "Agregando .gitignore y script de actualización - $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${GREEN}Commit de archivos adicionales realizado.${NC}"

# 13. Subir cambios adicionales
echo -e "${YELLOW}Subiendo cambios adicionales al repositorio remoto...${NC}"
git push -f origin main
echo -e "${GREEN}Cambios adicionales subidos correctamente.${NC}"

# 14. Verificar archivos alternativos creados
ALT_FILES=$(find . -maxdepth 1 -name "*_*.promt.md" -type f | sort)
if [ ! -z "$ALT_FILES" ]; then
    echo -e "${YELLOW}Archivos alternativos creados:${NC}"
    echo "$ALT_FILES"
    echo -e "Total de archivos alternativos: $(echo "$ALT_FILES" | wc -l)"
fi

# 15. Mostrar resumen final
echo -e "${GREEN}¡Proceso completado con éxito!${NC}"
echo -e "${YELLOW}Resumen:${NC}"
echo -e "  - Total de archivos .promt.md encontrados: $(echo "$ALL_PROMT_FILES" | wc -l)"
echo -e "  - Total de archivos .promt.md originales agregados: $(echo "$ADDED_FILES" | wc -l)"
if [ ! -z "$ALT_FILES" ]; then
    echo -e "  - Total de archivos alternativos creados: $(echo "$ALT_FILES" | wc -l)"
fi
echo -e "  - Total de archivos .promt.md en el repositorio: $(git ls-files "*.promt.md" | wc -l)"
echo -e "${GREEN}Los archivos .promt.md y archivos de configuración han sido actualizados en el repositorio.${NC}"
echo -e "${YELLOW}Repositorio remoto: git@github.com:jaun-rg/personal-promts.git (rama main)${NC}"
echo -e "${YELLOW}Nota: Los archivos alternativos tienen el formato 'ruta_archivo_original.promt.md' y contienen el mismo contenido que los originales.${NC}"
