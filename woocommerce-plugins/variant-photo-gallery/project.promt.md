# Especificación del plugin Variant Photo Gallery

Este documento describe las características específicas del plugin Variant Photo Gallery para WooCommerce.

**IMPORTANTE**: Este plugin debe implementarse siguiendo todas las directrices generales definidas en el archivo [wordpress.promt.md](../wordpress.promt.md).

## Información general

- Nombre del plugin: Variant Photo Gallery
- Prefijo para funciones globales: 'vpg_'
- Text domain: 'variant-photo-gallery'
- Prefijos permitidos: variant_photo_gallery, vpg, Variant_Photo_Gallery

## Funcionalidad principal

El plugin permite asociar múltiples imágenes con variantes de productos en WooCommerce y mostrar solo las imágenes asociadas con la variante seleccionada.

### Administración del plugin

#### Gestión de imágenes de variantes
- Por cada variante de producto se puede asociar 1 o más imágenes
- El código está en una carpeta includes/admin
- Dentro de includes/admin se encuentran el css, imágenes y js para la parte de administración
- La funcionalidad está asociada a la sección Productos del menú principal del administrador
- Interfaz para agregar/eliminar imágenes en cada variante de producto
- Guardar los cambios de imágenes asociadas a cada variante

#### Página de ajustes
- Accesible desde el administrador de plugins (enlace "Ajustes")
- Redirige a una sección dentro de Productos
- Opciones configurables:
  - Estilo de imagen:
    - Redonda
    - Cuadrada (por defecto)
  - Presentación de atributos:
    - Menú desplegable
    - Botón (por defecto)
  - Mostrar/ocultar nombre del atributo en el nombre del producto
- Botón para guardar las configuraciones en la base de datos

### Frontend

#### Visualización en la página de producto
- Cuando se selecciona una variante, muestra solo las imágenes asociadas a esa variante
- Oculta las imágenes que no están asociadas a la variante seleccionada
- Ejemplo: si se selecciona color rojo, solo se muestran las imágenes de la variante roja
- Ajusta el estilo de acuerdo a las configuraciones (redondo/cuadrado)
- Ajusta la presentación de atributos según configuración (menú/botón)
- Muestra/oculta el nombre del atributo en el título según configuración
- Los assets (CSS, JS, imágenes) están en una carpeta public/assets

## Estructura de archivos específica

- variant-photo-gallery.php: Archivo principal del plugin
- includes/
  - class-variant-photo-gallery.php: Clase principal
  - class-variant-photo-gallery-loader.php: Gestor de hooks
  - class-variant-photo-gallery-i18n.php: Internacionalización
  - class-variant-photo-gallery-public.php: Funcionalidad pública
  - admin/
    - class-variant-photo-gallery-admin.php: Funcionalidad de administración
    - class-variant-photo-gallery-settings.php: Página de ajustes
    - css/: Estilos de administración
    - js/: Scripts de administración
    - images/: Imágenes de administración
- public/
  - css/: Estilos públicos
  - js/: Scripts públicos
  - images/: Imágenes públicas
- languages/: Archivos de traducción
  - variant-photo-gallery.pot
  - variant-photo-gallery-es_ES.po
  - variant-photo-gallery-fr_FR.po
  - variant-photo-gallery-en_US.po

## Configuración específica

### Hooks de WordPress/WooCommerce
- woocommerce_product_after_variable_attributes: Para añadir campos de imágenes de variantes
- woocommerce_save_product_variation: Para guardar imágenes de variantes
- woocommerce_single_product_image_gallery_classes: Para añadir clases a la galería
- woocommerce_before_single_product: Para configurar la galería de variantes
- woocommerce_available_variation: Para añadir datos de imágenes a los datos de variación
- woocommerce_single_product_image_thumbnail_html: Para modificar el HTML de las imágenes

### Configuración de WooCommerce
- Requiere WooCommerce instalado y activo
- Compatible con WooCommerce 3.0.0 o superior
- Probado hasta WooCommerce 8.0.0

## Ambiente de pruebas específico

### Configuración del ambiente de pruebas
- Genera los siguientes atributos de producto si no existen:
  - color: azul, rojo
  - talla: S, M, L
- Genera un producto de prueba con variantes de color y talla si no existe
- Instala y habilita el plugin que estamos generando

## Empaquetado
- Incluye scripts en composer.json para empaquetar el proyecto en un zip
- Opciones de empaquetado:
  - package: Sin dependencias de desarrollo
  - package:full: Versión completa excluyendo archivos de desarrollo
