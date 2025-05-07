#!/bin/bash

# Script para gestionar archivos .promt.md y subirlos a un repositorio específico
# Autor: Juan José R. G.

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
REPO_URL="git@github.com:jaun-rg/personal-promts.git"
BRANCH="main"
TEMP_DIR="tmp"

# Verificar si tenemos acceso al repositorio
echo -e "${YELLOW}Verificando acceso al repositorio remoto...${NC}"
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${RED}No se pudo autenticar con GitHub. Verificando si el repositorio existe...${NC}"

    # Intentar con HTTPS en lugar de SSH
    HTTPS_URL="https://github.com/jaun-rg/personal-promts.git"
    if git ls-remote --heads "$HTTPS_URL" 2>/dev/null; then
        echo -e "${YELLOW}El repositorio existe pero no tienes acceso SSH. Usando HTTPS...${NC}"
        REPO_URL="$HTTPS_URL"
    else
        echo -e "${YELLOW}El repositorio no existe o no tienes acceso. Se creará localmente.${NC}"
    fi
else
    echo -e "${GREEN}Autenticación con GitHub exitosa.${NC}"
fi

echo -e "${YELLOW}Iniciando proceso de actualización de archivos .promt.md${NC}"

# 1. Buscar todos los archivos .promt.md en el sistema de archivos
echo -e "${YELLOW}Buscando archivos .promt.md...${NC}"
PROMT_FILES=$(find . -type f -name "*.promt.md" -not -path "./$TEMP_DIR/*" -not -path "./tmp/*" -not -path "./test_tmp/*" -not -path "./verify_tmp/*" -not -path "*/.git/*" | sort)

if [ -z "$PROMT_FILES" ]; then
    echo -e "${RED}No se encontraron archivos .promt.md${NC}"
    exit 1
fi

echo -e "${GREEN}Se encontraron los siguientes archivos .promt.md:${NC}"
echo "$PROMT_FILES"
echo -e "Total: $(echo "$PROMT_FILES" | wc -l) archivos"

# 2. Crear carpeta temporal
echo -e "${YELLOW}Creando carpeta temporal: $TEMP_DIR${NC}"
if [ -d "$TEMP_DIR" ]; then
    echo -e "${YELLOW}Eliminando carpeta temporal existente...${NC}"
    rm -rf "$TEMP_DIR"
fi
mkdir -p "$TEMP_DIR"

# 3. Obtener lo que está en origin en la carpeta temporal
echo -e "${YELLOW}Obteniendo contenido del repositorio remoto...${NC}"
cd "$TEMP_DIR"
git init
git remote add origin "$REPO_URL"

# Intentar clonar el repositorio remoto
echo -e "${YELLOW}Intentando clonar el repositorio remoto...${NC}"
if git fetch origin "$BRANCH" 2>/dev/null; then
    echo -e "${GREEN}Repositorio remoto clonado correctamente.${NC}"
    git checkout -b "$BRANCH" "origin/$BRANCH"
else
    echo -e "${YELLOW}No se pudo clonar el repositorio remoto. Inicializando nuevo repositorio.${NC}"
    git checkout -b "$BRANCH"
fi

# 4. Copiar los archivos .promt.md respetando la estructura actual
echo -e "${YELLOW}Copiando archivos .promt.md a la carpeta temporal...${NC}"
cd ..

# Crear un array para almacenar los archivos copiados
declare -a COPIED_FILES

# Método simplificado para copiar archivos manteniendo la estructura exacta
echo -e "${YELLOW}Creando estructura de directorios y copiando archivos...${NC}"

# Limpiar completamente la carpeta temporal excepto .git
find "$TEMP_DIR" -mindepth 1 -not -path "$TEMP_DIR/.git*" -delete 2>/dev/null || true

# Usar el método probado manualmente para copiar archivos
for file in $PROMT_FILES; do
    # Obtener la ruta relativa del archivo
    rel_path=${file:2}  # Eliminar './' del inicio
    dir_path=$(dirname "$rel_path")

    # Crear el directorio de destino en la carpeta temporal
    dest_dir="$TEMP_DIR/$dir_path"
    mkdir -p "$dest_dir"

    # Copiar el archivo preservando atributos
    cp -p "$file" "$TEMP_DIR/$rel_path"

    # Verificar si la copia fue exitosa
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}Copiado: $rel_path${NC}"
        COPIED_FILES+=("$rel_path")
    else
        echo -e "  ${RED}Error al copiar: $rel_path${NC}"
    fi
done

# Verificar la estructura creada
echo -e "${YELLOW}Verificando estructura creada en la carpeta temporal...${NC}"
cd "$TEMP_DIR"
find . -type f -name "*.promt.md" | sort | while read -r temp_file; do
    rel_path=${temp_file:2}  # Eliminar './' del inicio
    echo -e "  ${BLUE}Archivo en carpeta temporal: $rel_path${NC}"
done
cd ..

echo -e "${GREEN}Archivos .promt.md copiados a la carpeta temporal.${NC}"
echo -e "Total copiados: ${#COPIED_FILES[@]} archivos"

# 5. Versionar los cambios actuales con un número de versión
cd "$TEMP_DIR"

# Determinar el número de versión actual
if git tag | grep -q "^v[0-9]\+$"; then
    # Obtener la última versión y aumentarla en 1
    LAST_VERSION=$(git tag | grep "^v[0-9]\+$" | sort -V | tail -n 1 | sed 's/v//')
    VERSION=$((LAST_VERSION + 1))
else
    # Si no hay versiones previas, comenzar con la versión 1
    VERSION=1
fi

echo -e "${YELLOW}Versionando cambios como v$VERSION...${NC}"

# Agregar solo los archivos .promt.md (forzando la adición)
echo -e "${YELLOW}Agregando archivos .promt.md al repositorio (forzando la adición)...${NC}"
find . -type f -name "*.promt.md" | while read -r file; do
    rel_path=${file:2}  # Eliminar './' del inicio
    echo -e "  ${GREEN}Agregando: $rel_path${NC}"
    git add -f "$file"
done

# Verificar si hay cambios para confirmar
if git diff --cached --quiet; then
    echo -e "${YELLOW}No hay cambios para confirmar.${NC}"
else
    # Crear mensaje de commit con versión
    COMMIT_MSG="Update version: v$VERSION"

    echo -e "${YELLOW}Confirmando cambios...${NC}"
    git commit -m "$COMMIT_MSG"

    # Crear tag para la versión
    git tag -a "v$VERSION" -m "Version $VERSION"

    echo -e "${GREEN}Cambios confirmados como versión v$VERSION.${NC}"

    # 6. Subir los cambios al repositorio
    echo -e "${YELLOW}Subiendo cambios al repositorio remoto...${NC}"

    # Intentar subir los cambios
    if git push -f origin "$BRANCH" 2>/dev/null && git push -f origin --tags 2>/dev/null; then
        echo -e "${GREEN}Cambios subidos correctamente al repositorio remoto.${NC}"
    else
        echo -e "${YELLOW}No se pudieron subir los cambios al repositorio remoto.${NC}"
        echo -e "${YELLOW}¿Deseas continuar sin subir los cambios? (s/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Ss]$ ]]; then
            echo -e "${YELLOW}Continuando sin subir los cambios...${NC}"
        else
            echo -e "${RED}Operación cancelada por el usuario.${NC}"
            cd ..
            echo -e "${YELLOW}Eliminando carpeta temporal...${NC}"
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    fi
fi

# 7. Eliminar la carpeta temporal
cd ..
echo -e "${YELLOW}Eliminando carpeta temporal...${NC}"
rm -rf "$TEMP_DIR"
echo -e "${GREEN}Carpeta temporal eliminada.${NC}"

# 8. Verificar que se hayan subido los archivos y que la estructura sea correcta
echo -e "${YELLOW}Verificando que los archivos se hayan subido correctamente y que la estructura sea correcta...${NC}"
echo -e "${YELLOW}Clonando repositorio para verificación...${NC}"

VERIFY_DIR="verify_tmp"
if [ -d "$VERIFY_DIR" ]; then
    rm -rf "$VERIFY_DIR"
fi

mkdir -p "$VERIFY_DIR"
cd "$VERIFY_DIR"

if git clone "$REPO_URL" . 2>/dev/null; then
    echo -e "${GREEN}Repositorio clonado correctamente para verificación.${NC}"

    # Eliminar cualquier .gitignore existente para evitar problemas
    if [ -f ".gitignore" ]; then
        echo -e "${YELLOW}Eliminando .gitignore para verificación...${NC}"
        rm -f .gitignore
    fi

    # Contar archivos .promt.md en el repositorio
    REPO_FILES=$(find . -type f -name "*.promt.md" | sort)
    REPO_COUNT=$(echo "$REPO_FILES" | wc -l)

    echo -e "${GREEN}Archivos .promt.md en el repositorio:${NC}"
    for repo_file in $REPO_FILES; do
        rel_path=${repo_file:2}  # Eliminar './' del inicio
        echo -e "  ${BLUE}$rel_path${NC}"
    done
    echo -e "Total en repositorio: $REPO_COUNT archivos"

    # Verificar la estructura de directorios
    echo -e "${YELLOW}Verificando estructura de directorios en el repositorio...${NC}"
    REPO_DIRS=$(find . -type d -not -path "*/\.*" | sort)
    for repo_dir in $REPO_DIRS; do
        if [ "$repo_dir" != "." ]; then
            rel_dir=${repo_dir:2}  # Eliminar './' del inicio
            echo -e "  ${BLUE}Directorio: $rel_dir${NC}"
        fi
    done

    # Verificar si hay problemas de estructura (archivos con guiones bajos en lugar de barras)
    STRUCTURE_ISSUES=false
    for repo_file in $REPO_FILES; do
        if [[ "$repo_file" == *"_"* && "$repo_file" != *"/"*"/"* && "$repo_file" != "./manejo.promt.md" && "$repo_file" != "./generators/base.promt.md" ]]; then
            echo -e "${RED}Problema de estructura detectado: $repo_file${NC}"
            echo -e "${RED}Este archivo debería tener una estructura de directorios con barras, no guiones bajos.${NC}"
            STRUCTURE_ISSUES=true
        fi
    done

    # Verificar que cada archivo copiado esté en el repositorio con la estructura correcta
    echo -e "${YELLOW}Verificando que cada archivo copiado esté en el repositorio con la estructura correcta...${NC}"
    ALL_FOUND=true
    for copied_file in "${COPIED_FILES[@]}"; do
        # Verificar si el archivo existe con la ruta exacta
        if find . -path "./$copied_file" -type f | grep -q .; then
            echo -e "  ${GREEN}Archivo encontrado con estructura correcta: $copied_file${NC}"
        else
            # Verificar si existe con una ruta alternativa (guiones bajos en lugar de barras)
            alt_path=$(echo "$copied_file" | sed 's/\//_/g')
            if find . -path "./$alt_path" -type f | grep -q .; then
                echo -e "  ${RED}Archivo encontrado pero con estructura incorrecta: $alt_path${NC}"
                echo -e "  ${RED}Debería ser: $copied_file${NC}"
                ALL_FOUND=false
                STRUCTURE_ISSUES=true
            else
                echo -e "  ${RED}¡Archivo no encontrado en el repositorio: $copied_file!${NC}"
                ALL_FOUND=false
            fi
        fi
    done

    # Verificar si el script update_promts.sh está en el repositorio
    if [ -f "update_promts.sh" ]; then
        echo -e "${GREEN}Script update_promts.sh encontrado en el repositorio.${NC}"
    else
        echo -e "${RED}Script update_promts.sh no encontrado en el repositorio.${NC}"
        echo -e "${YELLOW}Copiando script update_promts.sh al repositorio...${NC}"
        cp ../update_promts.sh .
        git add update_promts.sh
        git commit -m "Agregar script update_promts.sh"
        git push origin "$BRANCH"
    fi

    if [ "$ALL_FOUND" = true ] && [ "$STRUCTURE_ISSUES" = false ]; then
        echo -e "${GREEN}¡Verificación exitosa! Todos los archivos fueron subidos correctamente con la estructura adecuada.${NC}"
    else
        echo -e "${RED}¡Se encontraron problemas de estructura o archivos faltantes!${NC}"
        echo -e "${YELLOW}Corrigiendo problemas de estructura...${NC}"

        # Limpiar el repositorio y volver a copiar los archivos con la estructura correcta
        find . -name "*.promt.md" -type f -delete

        # Copiar los archivos originales con la estructura correcta
        cd ..
        for file in $PROMT_FILES; do
            rel_path=${file:2}  # Eliminar './' del inicio
            dir_path=$(dirname "$rel_path")

            # Crear el directorio de destino en la carpeta de verificación
            dest_dir="$VERIFY_DIR/$dir_path"
            mkdir -p "$dest_dir"

            # Copiar el archivo
            cp -p "$file" "$VERIFY_DIR/$rel_path"
            echo -e "  ${GREEN}Copiado con estructura correcta: $rel_path${NC}"
        done

        # Copiar el script update_promts.sh
        cp update_promts.sh "$VERIFY_DIR/"

        # Commit y push de los cambios
        cd "$VERIFY_DIR"
        git add -A
        git commit -m "Corregir estructura de directorios y agregar script update_promts.sh"
        git push -f origin "$BRANCH"

        echo -e "${GREEN}¡Estructura corregida y cambios subidos al repositorio!${NC}"
    fi

    cd ..
    rm -rf "$VERIFY_DIR"
else
    echo -e "${RED}No se pudo clonar el repositorio para verificación.${NC}"
fi

echo -e "${GREEN}¡Proceso completado con éxito!${NC}"
echo -e "${YELLOW}Resumen:${NC}"
echo -e "  - Total de archivos .promt.md encontrados: $(echo "$PROMT_FILES" | wc -l)"
echo -e "  - Total de archivos .promt.md copiados: ${#COPIED_FILES[@]}"
echo -e "  - Versión: v$VERSION"
echo -e "${GREEN}Los archivos .promt.md han sido actualizados en el repositorio.${NC}"
echo -e "${YELLOW}Repositorio remoto: $REPO_URL (rama $BRANCH)${NC}"
