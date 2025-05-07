# Características generales para proyectos de WordPress

Este archivo contiene las directrices y configuraciones estándar que deben aplicarse a todos los proyectos de WordPress.

## Estructura de código

### Estándares de codificación
- Todos los comentarios de código deben estar en inglés
- Añadir comentarios de documentación de archivo (file doc comment) a todos los archivos PHP con los siguientes tags: @package, @subpackage, @author, @license, @link, @since
  ```php
  <?php
  /**
   * Descripción corta del archivo.
   *
   * Descripción más detallada del archivo (si es necesaria).
   *
   * @package    Project_Name
   * @subpackage Project_Name/includes
   * @author     Your Name
   * @license    GPL-2.0-or-later
   * @link       https://example.com/project-name
   * @since      1.0.0
   */
  ```
- Incluir una descripción corta del archivo en la primera línea
- Incluir una descripción más detallada después de la descripción corta
- Colocar @since después de @link en los comentarios de archivo
- Añadir puntos finales a todos los comentarios en línea y que tengan solo un espacio
- Usar comparaciones estrictas (=== en lugar de ==) y condiciones Yoda
  - Colocar el valor literal a la izquierda de la comparación (por ejemplo, 'round' === $options['image_style'])
  - Usar in_array() con el tercer parámetro true para comparaciones estrictas
- Implementar verificación de nonce en formularios
  - Usar check_admin_referer() para verificar nonces en formularios de administración
  - Usar wp_verify_nonce() para verificar nonces en formularios públicos
- Usar wp_unslash() antes de sanitizar datos de $_POST
  - Aplicar wp_unslash() antes de sanitize_text_field() u otras funciones de sanitización
- Usar funciones de escape apropiadas para la salida
  - Usar esc_html_e() para texto normal
  - Usar esc_attr_e() para atributos HTML
  - Usar esc_url() para URLs
  - Usar esc_html__() cuando se necesita el valor de retorno
- Seguir las convenciones de nomenclatura de WordPress
  - Usar CamelCase para nombres de clase (por ejemplo, Class_Name)
  - Usar guiones bajos para separar palabras en nombres de funciones y variables
  - Añadir prefijos específicos del proyecto a las funciones globales
- Usar tabulaciones para la indentación, no espacios
- Mantener una indentación consistente en todo el código
- Marcar parámetros no utilizados con comentarios phpcs:ignore
  - Usar // phpcs:ignore Generic.CodeAnalysis.UnusedFunctionParameter.FoundAfterLastUsed
  - Documentar los parámetros no utilizados en el bloque de comentarios de la función
- Nota: No todas las clases necesitan recibir $plugin_name y $version en su constructor. Solo aquellas que los utilizan para funcionalidades específicas como enqueue de scripts y estilos.

### Estructura de archivos
- Separar claramente el código de administración y el código público
  - El código de Administración del plugin está en una carpeta includes/admin
  - El código publico php del plugin y que puede ser usado en el frontend está en una carpeta includes/frontend (no agregar el sufijo public)

- Mantener assets (CSS, JS, imágenes) en carpetas separadas para administración y frontend
  - Dentro de includes/admin se encuentran el css, imágenes y js para la parte de administración
  - Dentro de public se encuentran el css, imágenes y js para la parte de frontend (no agregar el sufijo public)
- Excluir de análisis y control de versiones los archivos en carpetas vendor, .docker, .sca, .vscode

## Funcionalidades estándar de plugins

### Administración
- Implementar las siguientes funcionalidades básicas:
  - Instalar
  - Desinstalar
  - Activar
  - Desactivar
  - Ajustes (si es necesario)

### Internacionalización
- Incluir una carpeta 'languages' con los siguientes archivos:
  - Plantilla de traducción base
  - Traducción al español
  - Traducción al inglés
  - otras traducciones que se especifiquen
- Utilizar la función load_plugin_textdomain() para cargar las traducciones
- Usar funciones de internacionalización como esc_html__(), esc_html_e(), etc. para todas las cadenas de texto visibles

### Configuración de WooCommerce
- Requiere WooCommerce instalado y activo
- Compatible con WooCommerce 3.0.0 o superior
- Probado hasta WooCommerce 8.0.0

## Ambiente de desarrollo

### Docker
- Carpeta .docker/  para los recursos docker
  - docker-compose.yml para configurar los servicios
  - Dockerfile
  - soporte para , wordpress y woocomerce y xdebug
  - scripts necesarios
  - monta en data/db los datos de la base de datos
  - monta en data/wordpress los archivos de WordPress
- Usar variables de entorno compartidas para la configuración
  - Comparte las variables como db name, host, usuario y password de la db asociados a la conexion de wordpress en todos los servicios donde se repite
- Implementar healthchecks en los servicios
- Incluir .dockerignore para excluir archivos innecesarios
- Configurar entorno de desarrollo:
  - el entorno de desarrollo debe configurarse para usar docker-compose.yml por lo que tambien debemos poder ejecutar php, composer, wpcli
  - Usa un contenedor intermedio para ejecutar comandos de php, composer y wpcli en lugar de un entrypoint en el Dockerfile
- Configurar entorno de depuración:
  - Archivo custom.ini para configuración de PHP (con errores habilitados) y Xdebug
  - WordPress en modo debug
- Configuración del ambiente de pruebas:
  - Verifica que la db esté operando para ejecutar WordPress
  - Verifica que WordPress esté listo y da un tiempo de espera; en caso contrario instala WordPress
  - Instala WooCommerce en el Dockerfile; verifica si está activado y en caso contrario lo activa


### Análisis de código y QA

#### PHPUnit
- Configurar PHPUnit como dependencia de desarrollo
- Incluir scripts en composer.json:
  - test: para ejecutar pruebas unitarias
  - test:coverage: para generar informes de cobertura
- Configurar phpunit.xml para:
  - Usar PHPUnit 9.x con soporte para PHP 8.x
  - Incluir archivos de código fuente relevantes
  - Excluir directorios vendor, tests, .sca y .docker
  - Configurar variables de entorno para pruebas de WordPress
- Incluir archivo tests/wp-config.php para el entorno de pruebas

#### Dependencias de desarrollo
- squizlabs/php_codesniffer: Para análisis de estilo de código
- wp-coding-standards/wpcs: Estándares de codificación de WordPress
- phpcompatibility/phpcompatibility-wp: Compatibilidad con diferentes versiones de PHP
- dealerdirect/phpcodesniffer-composer-installer: Instalador de estándares para PHPCS
- phpstan/phpstan: Para análisis estático de código
- phpstan/extension-installer: Instalador de extensiones para PHPStan
- szepeviktor/phpstan-wordpress: Reglas de PHPStan para WordPress
- vimeo/psalm: Para análisis estático de código
- humanmade/psalm-plugin-wordpress: Plugin de Psalm para WordPress
- php-stubs/wordpress-stubs: Stubs de WordPress para análisis estático
- php-stubs/woocommerce-stubs: Para análisis estático con soporte de WooCommerce
- phpcsstandards/phpcsutils: Utilidades para PHP CodeSniffer

#### Archivos de configuración
- Carpeta .sca/ para archivos de configuración de análisis de código:
  - phpcs.xml: Configuración para PHP CodeSniffer
    - Usar WordPress como estándar base
    - Excluir carpetas vendor, node_modules, .docker, dist, build .docker y .sca
    - Deshabilitar caché
    - Configurar text domain y prefijos permitidos específicos del proyecto
  - phpstan.neon: Configuración para PHPStan
    - Nivel de análisis 5
    - Deshabilitar caché
    - Configurar reportUnmatchedIgnoredErrors: false
    - Configurar treatPhpDocTypesAsCertain: false
    - Excluir carpetas vendor, node_modules, .docker, dist, build .docker y .sca
    - Ignorar errores comunes de WordPress
  - psalm.xml: Configuración para Psalm
    - Usar stubs de WordPress
    - Excluir carpetas vendor, node_modules, .docker, dist, build .docker y .sca
    - Permitir inclusión de archivos
    - Deshabilitar caché
    - Mejorar análisis con useDocblockTypes, usePhpDocMethodsWithoutMagicCall, etc.
    - Suprimir errores comunes de WordPress
    - Configurar MissingReturnType y ClassMustBeFinal como issues de tipo "info"
    - IMPORTANTE: No generar archivos .sca/0 o .sca/file-doc-comment-template.php

#### Scripts de Composer
- install:post: crea directorios necesarios (.docker/data/db, .docker/data/wordpress, dist build) e instala hooks de pre-commit
- lint: analiza el proyecto con phpcs
- fix: corrige formato con phpcbf
- sca:psalm: ejecuta análisis con psalm (--no-cache, --alter, --issues=MissingReturnType,ClassMustBeFinal)
- sca:phpstan: ejecuta análisis con phpstan (--memory-limit=512M)
- sca: ejecuta sca:psalm y sca:phpstan en secuencia
- analyze: ejecuta fix, lint y sca en secuencia
- Scripts para gestionar el entorno Docker:
  - docker:up
  - docker:down
  - docker:restart
  - docker:logs
  - docker:bash
  - docker:wpcli
- package: crea paquete zip sin dependencias de desarrollo
- package:full: crea paquete zip completo excluyendo archivos de desarrollo

#### Configuración adicional de Composer
- Usar wp-coding-standards/wpcs versión 3.1.0 para compatibilidad con PHP 8.4
- Configurar plataforma PHP como 8.4.6
- Especificar versión de PHP como ">=7.2"
- Permitir plugins específicos en "config.allow-plugins"
- Instalar dependencias necesarias para análisis de código

#### Pre-commit hooks
- Configurar .pre-commit-config.yaml para integración con Git:
  - php-fix: ejecuta composer fix
  - php-lint: ejecuta composer lint
  - php-sca: ejecuta composer sca
- Usar comandos de composer en lugar de rutas directas
- Añadir verbose: true para mostrar salida detallada
- Instalar automáticamente con composer install:post

### Visual Studio Code
- Incluir carpeta .vscode con configuración para proyectos WordPress
- Recomendar plugins útiles para desarrollo WordPress en el archivo extensions.json:
  - Desarrollo:
    - "ms-vscode-remote.remote-containers"
    - "DEVSENSE.phptools-vscode"
    - "kotfire.php-add-property"
    - "st-pham.php-refactor-tool"
    - "neilbrayfield.php-docblocker" - Para generar bloques de documentación PHP
    - "mehedidracula.php-namespace-resolver" - Para resolver namespaces en PHP
  - QA y análisis:
    - "xdebug.php-debug" - Para depuración con Xdebug
    - "shevaua.phpcs" - Para análisis de código con PHP_CodeSniffer
    - "persoderlind.vscode-phpcbf" - Para corrección automática de código con PHPCBF
    - "getpsalm.psalm-vscode-plugin" - Para análisis estático con Psalm
    - "SanderRonde.phpstan-vscode" - Para análisis estático con PHPStan

- Configurar el proyecto para usar el .docker/Dockerfile (remote-containers, phptools-vscode y demás plugins)
   - IMPORTANTE: composer y php no estan instalados de manera local y no se deben instalar localmente
- Configurar settings.json:
  - Formato de código
  - Rutas de ejecución para herramientas de análisis relativas a vendor
  - Archivos de configuración para cada herramienta relativas a .sca
  - Exclusión de carpetas para análisis
  - Configuración de Intelephense para WordPress
    - Añade los stubs de WordPress y WooCommerce a intelephense.stubs
    - Configura intelephense.environment.includePaths para incluir los stubs de WordPress y WooCommerce
  - Configuración de Xdebug
- Configurar launch.json para
  - depuración de PHP asociado a l servicio Worpress ejecutando en Docker
  - Mapeo de rutas entre el contenedor Docker y el sistema de archivos local
- Excluir archivos en .sca y .docker/data para mejorar rendimiento

### Control de versiones
- Incluir .gitignore con reglas estándar para WordPress
- Añadir exclusiones específicas:
  - # .vscode
  - .docker/data
  - vendor
  - *.bk
  - *.bk.*
  - *.zip
  - .sca/0

## Documentación
- Incluir README.md con la siguiente información:
  - Descripción del proyecto
  - Características
  - Estructura de directorios
  - Lista de dependencias
  - Instrucciones de instalación
  - Instrucciones de ejecución
  - Referencias y recursos adicionales

## Tareas finales de verificación
- estas tareas se necesitan ejecutar despues de crear todos los recursos del proyecto
- Ejecutar "composer docker:up" para tener un ambiente PHP con el cual trabajar y corregir errores si tenemos problemas
- Ejecutar "composer install" y resolver errores de compatibilidad
- Ejecutar "composer install:post"
- Ejecutar "composer lint" y corregir errores
- Ejecutar "composer sca:psalm" y corregir errores
- Ejecutar "composer sca:phpstan" y corregir errores
- Ejecutar "composer analyze" para verificación final

## Solución de problemas comunes

### Errores de PHPStan
- Para errores relacionados con tipos: añadir anotaciones de tipo en PHPDoc
- Para propiedades nunca leídas: añadir métodos getter
- Para errores de tipos en PHPDoc: configurar treatPhpDocTypesAsCertain: false
- Para métodos de clases desconocidas: añadir verificaciones is_object() y method_exists()
- Para errores de tipo incorrecto en esc_attr(): convertir explícitamente a string con (string)
- Para errores con clases de WordPress/WooCommerce: usar 'object' como tipo en PHPDoc, pero en la descripcion poner la clase original entre paréntesis
- Para errores con métodos de clases de WordPress/WooCommerce: verificar si el método existe

### Errores de Psalm
- Para errores relacionados con hooks: verificar que existan y tengan los argumentos correctos
- Asegurar que los plugins y stubs necesarios estén instalados

### Errores de PHPCS
- Para "Missing file doc comment": añadir comentarios de documentación
- Para "There must be no blank lines before the file comment": eliminar líneas en blanco o excluir regla
- Para "Inline comments must end in full-stops": añadir puntos finales
- Para "Line indented incorrectly": corregir indentación usando tabulaciones
- Para "The method parameter $i is never used": marcar con phpcs:ignore
