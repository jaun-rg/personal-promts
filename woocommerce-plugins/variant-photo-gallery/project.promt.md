# Especificación del plugin

Este documento describe las características específicas de un plugin para WooCommerce.

**IMPORTANTE**: Este plugin debe implementarse siguiendo todas las directrices generales definidas en el archivo [wordpress.promt.md](../wordpress.promt.md) por lo que necesitas analizarlo.

## Información general

- Descripcion: plugin permite asociar múltiples imágenes con variantes de productos en WooCommerce
- version: 1.0.0

- repositorio: git@github.com:jaun-rg/wp-plugins-variant-photo-gallery.git
- la carpeta actual es la raiz del proyecto
- IMPORTANTE: version de php: 8.1.31

## Funcionalidad principal

El plugin permite asociar múltiples imágenes con variantes de productos en WooCommerce y mostrar solo las imágenes asociadas con la variante seleccionada.

- Por cada variante de producto se puede asociar 1 o más imágenes

### Administración del plugin

#### Caracteristicas generales

- La funcionalidad está asociada a Productos
- Interfaz para agregar/eliminar imágenes
- Guardar los cambios

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
- Botón para guardar las configuraciones en la base de datos

### Frontend

#### Visualización en la página de producto
- Cuando se selecciona una variante, muestra solo las imágenes asociadas a esa variante
- Oculta las imágenes que no están asociadas a la variante seleccionada
- Ejemplo: si se selecciona color rojo, solo se muestran las imágenes de la variante roja
- Ajusta el estilo de acuerdo a las configuraciones (redondo/cuadrado)
- Ajusta la presentación de atributos según configuración (menú/botón)

## Ambiente de pruebas específico

### Configuración del ambiente de pruebas
- Instala y habilita el plugin que estamos generando
- Genera los siguientes atributos de producto si no existen:
  - color: azul, rojo, morado
  - talla: S, M, L
- Genera un producto de prueba con variantes de color y talla si no existe
