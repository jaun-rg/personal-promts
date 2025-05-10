# Características generales para proyectos de WordPress

Este archivo contiene las directrices y configuraciones estándar que deben aplicarse a todos los proyectos de WordPress.

## Información general
- Text domain: Nombre del plugin en dash-case
- Prefijos permitidos (incluyendo para funciones globales):
   - Nombre del plugin en snack-case,
   - Nombre del plugin en  pascal case pero con separacion de guiones bajos (ejemplo: Hola_Mundo)

- si se especifica repositorio, necesitas:
	- inicializar el proyecto git (git init)
 	- asociar el repositorio (git remote add origin {repositorio})

## Documentación
- Incluir README.md con la siguiente información:
  - Descripción del proyecto
  - Características
  - Estructura de directorios
  	- descripcion de cada directorio y archivo principal
  - Lista de dependencias
  - Instrucciones de instalación
  - Instrucciones de ejecución
  - Referencias y recursos adicionales

## Estructura de proyecto

### Estructura de archivos
- Separar claramente el código de administración y el código público, incluyendo assets (css js, iamgenes y demás)
  - includes/admin:  carpeta para el código de Administración del plugin
  - public: carpeta para el código publico php del plugin y que puede ser usado en el frontend (IMPORTANTE: public no debe estar dentro de includes, debe estar en la raiz del proyecto)

### IMPORTANTE: Estándares de codificación
-  nombre de archivos php en dash case
  - no uses el prefijo "class-" en el nombre de los archivos generados
  - no uses los sufijos "public" o "admin" en el nombre de los archivos generados
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
   * @author     Your Name <your email o repo account>
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
- No dejar líneas en blanco antes del comentario de documentación del archivo
- Asegurarse de que todos los archivos PHP tengan un comentario de documentación
- Terminar todos los comentarios en línea con un punto final
- Usar tabulaciones para la indentación, no espacios
- Usar el prefijo del plugin para todas las funciones globales

### Configuraciones

### Dependencias Generales
- php ultima version (a menos que se especifique lo contrario)
- composer

#### .gitignore
- Usar .gitignore con reglas estándar para WordPress
- Añadir exclusiones específicas:
  - # .vscode
  - *.lock
  - .docker/data
  - vendor
  - dist
  - build
  - *.bk
  - *.bk.*
  - *.zip
  - .sca/0

#### Composer
- Usar wp-coding-standards/wpcs versión 3.1.0 para compatibilidad con PHP 8.4
- Configurar plataforma PHP como 8.4.6
- Especificar versión de PHP como ">=7.2"
- Permitir plugins específicos en "config.allow-plugins"
    - dealerdirect/phpcodesniffer-composer-installer
		- phpstan/extension-installer
		- brainmaestro/composer-git-hooks
- usa composer-git-hooks para manejo de los hooks
  - Configuración en composer.json:
    ```json
    "extra": {
      "hooks": {
        "pre-commit": [
          "composer fix",
          "composer lint",
          "composer sca"
        ]
      }
    }
    ```
  - configurar omposer-git-hooks fuera de composer.json ha presentado errores
- scripts
  - install:post:
    - crea directorios necesarios
      - .docker/data/db
      - .docker/data/wordpress
      - dist
      - build
    -  ejecuta los comandos
		- "rm -f cghooks.lock"
		- "vendor/bin/cghooks add --force"
  - lint: analiza el proyecto con phpcs
  - fix: corrige formato con phpcbf
  - sca:psalm: ejecuta análisis con psalm (SIEMPRE agrega las opciones --no-cache, --no-progress, --alter, "--issues=MissingReturnType,InvalidReturnType", --config=.sca/psalm.xml)
  - sca:phpstan: ejecuta análisis con phpstan (--memory-limit=1G --configuration=.sca/phpstan.neon .)
  - sca: ejecuta sca:psalm y sca:phpstan en secuencia
  - analyze: ejecuta fix, lint y sca en secuencia
  - test: para ejecutar pruebas unitarias
  - test:coverage: para generar informes de cobertura
  - Scripts para gestionar el entorno Docker:
    - docker:up
		- crea las carpetas .docker/data/db y .docker/data/wordpress antes de ejecutar el comando principal
    - docker:down
    - docker:restart
    - docker:logs
    - docker:bash
    - docker:wpcli
  - package:
    - elimina carpeta vendor
    - ejecuta "composer install" para descargar dependencias de produccion
    - crea paquete zip con dependencias de produccion,  excluyendo  dependencias , archivos de desarrollo y pruebas y archivos de configuración innecesarios
- dependencias de desarrollo:
  - brainmaestro/composer-git-hooks: Para ejecutar scripts antes de confirmar cambios
  - squizlabs/php_codesniffer: Para análisis de estilo de código
  - wp-coding-standards/wpcs: Estándares de codificación de WordPress
  - phpcompatibility/phpcompatibility-wp: Compatibilidad con diferentes versiones de PHP
  - dealerdirect/phpcodesniffer-composer-installer: Instalador de estándares para PHPCS
  - phpstan/phpstan: Para análisis estático de código
  - phpstan/extension-installer: Instalador de extensiones para PHPStan
  - szepeviktor/phpstan-wordpress: Reglas de PHPStan para WordPress
  - vimeo/psalm: Para análisis estático de código
  	- IMPORTANTE: si la version de PHP es igua o mayor a 8, SIEMPRE usar version 6.0 o superior de psalm y ejecuta composer require --dev vimeo/psalm:^6.0 --update-with-dependencies
  - humanmade/psalm-plugin-wordpress: Plugin de Psalm para WordPress
  - php-stubs/wordpress-stubs: Stubs de WordPress para análisis estático
  - php-stubs/woocommerce-stubs: Para análisis estático con soporte de WooCommerce
  - php-stubs/wordpress-globals: Para análisis estático con soporte de variables globales de WordPress
  - php-stubs/wp-cli-stubs: Para análisis estático con soporte de WP-CLI
  - phpcsstandards/phpcsutils: Utilidades para PHP CodeSniffer

### Pruebas
- Configurar PHPUnit como dependencia de desarrollo
- Configurar phpunit.xml para:
  - Usar PHPUnit 9.x con soporte para PHP 8.x
  - Incluir archivos de código fuente relevantes
  - Excluir directorios .sca y .docker
  - Configurar variables de entorno para pruebas de WordPress
- Incluir archivo tests/wp-config.php para el entorno de pruebas

#### Analisis de código y vulnerabilidades
- Carpeta .sca/ para archivos de configuración de análisis de código:
  - phpcs.xml: Configuración para PHP CodeSniffer
    - Usar WordPress como estándar base
    - Excluir carpetas vendor, node_modules, .docker, dist, build .docker y .sca
    - Excluir archivos de prueba como tests/wp-config.php y tests/bootstrap.php
    - Deshabilitar caché
    - Configurar text domain y prefijos permitidos específicos del proyecto
  - phpstan.neon: Configuración para PHPStan
    - Nivel de análisis 5
    - Deshabilitar caché
    - Configurar reportUnmatchedIgnoredErrors: false
    - Configurar treatPhpDocTypesAsCertain: false
    - Excluir carpetas vendor, node_modules, .docker, dist, build .docker y .sca
    - Ignorar errores comunes de WordPress y WooCommerce:
      ```yaml
      ignoreErrors:
          # WordPress specific errors
          - '#^Function [a-zA-Z0-9\\_]+ not found.$#'
          - '#^Call to static method [a-zA-Z0-9\\_]+\(\) on an unknown class [a-zA-Z0-9\\_]+.$#'
          - '#^Access to property \$[a-zA-Z0-9_]+ on an unknown class [a-zA-Z0-9\\_]+.$#'
          - '#^Call to method [a-zA-Z0-9\\_]+\(\) on an unknown class [a-zA-Z0-9\\_]+.$#'
          - '#^Parameter \$[a-zA-Z0-9_]+ of function [a-zA-Z0-9\\_]+ has invalid type [a-zA-Z0-9\\_]+.$#'
          - '#^Class [a-zA-Z0-9\\_]+ not found.$#'
          - '#^Instantiated class [a-zA-Z0-9\\_]+ not found.$#'
          - '#^Call to method [a-zA-Z0-9\\_]+\(\) on an unknown class WC_[a-zA-Z0-9\\_]+.$#'
          - '#^Call to method [a-zA-Z0-9\\_]+\(\) on an unknown class WP_[a-zA-Z0-9\\_]+.$#'
          - '#^Access to property \$[a-zA-Z0-9_]+ on an unknown class WC_[a-zA-Z0-9\\_]+.$#'
          - '#^Access to property \$[a-zA-Z0-9_]+ on an unknown class WP_[a-zA-Z0-9\\_]+.$#'
          - '#^Parameter \$[a-zA-Z0-9_]+ of method [a-zA-Z0-9\\_]+::[a-zA-Z0-9\\_]+\(\) has invalid type [a-zA-Z0-9\\_]+.$#'
          - '#^Property [a-zA-Z0-9\\_]+::\$[a-zA-Z0-9_]+ has unknown class [a-zA-Z0-9\\_]+ as its type.$#'
          - '#^Property [a-zA-Z0-9\\_]+::\$[a-zA-Z0-9_]+ is never read, only written.$#'
          - '#^Constant [A-Z0-9\\_]+ not found.$#'
          - '#^Class [a-zA-Z0-9\\_]+ referenced with incorrect case: [a-zA-Z0-9\\_]+.$#'
          - '#^Offset .+ on array.+ in isset\(\) always exists and is not nullable.$#'
      ```
  - psalm.xml: Configuración para Psalm
    - Usar stubs de WordPress, WooCommerce, WordPress Globals y WP-CLI
    - Excluir carpetas vendor, .docker, dist, build .docker y .sca
	- SIEMPRE Verifica si la carpeta node_modules existe antes de Excluir
	- IMPORTANTE:
		- los mensajes Deprecated: Constant E_STRICT is deprecated no afectan la funcionalidad del plugin, por lo que se puede ignorar
		- no es aceptable proponer esta solución: Si hay problemas de compatibilidad con PHP 8.4, modificar el script sca:psalm en composer.json:
			```json
			"sca:psalm": "echo 'Skipping Psalm due to compatibility issues with PHP 8.4'"
			```
		- no agregues el atributo cacheDirectory en la etiqueta <psalm> SIEMPRE
		- agregues el atributo resolveFromConfigFile="false" en la etiqueta <psalm> SIEMPRE

    - Permitir inclusión de archivos
    - Usar el plugin humanmade/psalm-plugin-wordpress
    - IMPORTANTE:

#### Docker
- Carpeta .docker/  para los recursos docker
  - docker-compose.yml para configurar los servicios; debe estar dentro de la carpeta .docker/ (NO en la raíz del proyecto)
  - Dockerfile
  - scripts necesarios
  - Archivo custom.ini para configuración de PHP (con errores habilitados) y Xdebug

---

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

---

## Configuración del Ambiente de desarrollo
### Docker
- en docker-compose.yml configura los servicios
  - Implementar healthchecks en los servicios
  	- valores start_period para los servicios:
		- db: 60s
		- wordpress: 60s
		- wpcli: 60s
		- ravent-mock: 30s
- Dockerfile con soporte al menos de  wordpress , woocomerce y xdebug
  - Instala WooCommerce
  - monta en data/db los datos de la base de datos
  - monta en data/wordpress los archivos de WordPress
  - monta custom.ini y
  - WordPress en modo debug
  - Usar variables de entorno compartidas para la configuración
    - Comparte las variables como db name, host, usuario y password de la db asociados a la conexion de wordpress en todos los servicios donde se repite
  - IMPORTANTE: queda EXTRICTAMENTE prohibido usar entrypoint asi como copiar, montar , usar el archivo setup.sh  u otro script en el Dockerfile
- Incluir .dockerignore para excluir archivos innecesarios
- configura un script setup.sh para:
  - Verificar que la db esté operando para ejecutar WordPress
  - Verificar que WordPress esté listo y da un tiempo de espera; en caso contrario instala WordPress
  - Verificar si está activado y en caso contrario lo activa
  - Configuración del wordpress y woocomerce que sean solicitados (como crear usuarios, productos, etc.)
- Usa un contenedor intermedio para ejecutar comandos de wpcli
- IMPORTANTE:
	- setup.sh SOLO debe montarse en el contenedor intermedio para ejecutar comandos de wpcli
	- se ejecuta automáticamente al iniciar el contenedor
	- se necesita hacer un healthcheck asociado a la ejecutar setup.sh

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
- Configurar settings.json:
  - Formato de código
  - Rutas de ejecución para herramientas de análisis relativas a vendor
  - Archivos de configuración para cada herramienta relativas a .sca
  - Exclusión de carpetas para análisis
  - Configuración de Intelephense para WordPress
    - Agrega configuracion para incluir los stubs de WordPress y WooCommerce,
	- Incluye lo la siguiente configuracion para incluir los paths de stubs de wordpress y woocomerce  y excluir errores
	```json
	"intelephense.environment.includePaths": [
    "./vendor/php-stubs/wordpress-stubs",
    "./vendor/php-stubs/woocommerce-stubs",
    "./vendor/php-stubs/wordpress-globals",
    "./vendor/php-stubs/wp-cli-stubs"
	],
	"intelephense.diagnostics.undefinedFunctions": false,
	"intelephense.diagnostics.undefinedConstants": false,
	"intelephense.diagnostics.undefinedClassConstants": false,
	"intelephense.diagnostics.undefinedMethods": false,
	"intelephense.diagnostics.undefinedProperties": false,
	"intelephense.diagnostics.undefinedTypes": false,
	"intelephense.diagnostics.unusedSymbols": false,
	"intelephense.diagnostics.unusedVariables": false,
	"intelephense.format.braces": "k&r"
	```
  - Configuración de phptools-vscode para WordPress
    - Añade los stubs de WordPress y WooCommerce
    - Configura phpTools.stubs para incluir los stubs de WordPress y WooCommerce
    - Configura phpTools.includePaths para incluir los stubs de WordPress y WooCommerce instalados por Composer
    - Crea un archivo phpTools.json en la carpeta .vscode para configurar los stubs y rutas de inclusión específicamente para DEVSENSE.phptools-vscode
  - Configuración de Xdebug
- Configurar launch.json para
  - depuración de PHP asociado al servicio Worpress ejecutado en Docker
  - Mapeo de rutas entre el contenedor Docker y el sistema de archivos local
- Excluir archivos en .sca y .docker/data para mejorar rendimiento
- configurar phpTools.json para phptools-vscode:
  - Crea un archivo phpTools.json en la carpeta .vscode con la configuración específica:
  ```json
  {
      "$schema": "https://phptools.devsense.com/schemas/phptools.json",
      "stubs": [
          {
              "name": "wordpress",
              "path": "./vendor/php-stubs/wordpress-stubs/wordpress-stubs.php"
          },
          {
              "name": "woocommerce",
              "path": "./vendor/php-stubs/woocommerce-stubs/woocommerce-stubs.php"
          },
          {
              "name": "wordpress-globals",
              "path": "./vendor/php-stubs/wordpress-globals/wordpress-globals.php"
          },
          {
              "name": "wp-cli",
              "path": "./vendor/php-stubs/wp-cli-stubs/wp-cli-stubs.php"
          }
      ],
      "includePaths": [
          "./vendor/php-stubs/wordpress-stubs",
          "./vendor/php-stubs/woocommerce-stubs",
          "./vendor/php-stubs/wordpress-globals",
          "./vendor/php-stubs/wp-cli-stubs"
      ],
      "language": "en",
      "codeAnalysis": {
          "run": true,
          "failOnError": false
      }
  }
  ```
  - Asegúrate de que la versión de PHP en phpTools.json coincida con la versión de PHP que estás utilizando.

---

## Tareas
- toma en cuenta que te estare solic ejecutar estas tareas

### Actualiza configuracion
- lee los archivos project.promt.md y demás archivos .promt.md involucrados
- genera y actualiza los archivos de configuracion del proyecto de acuerdo a los lineamientos
- Asegúrate de seguir los estándares de codificación actualizados y agregar configuracion para prevenir errores comunes de PHPCS, PHPStan, PSalm, phptools-vscode  referentes a archivos de configuracion

### Actualiza estandares
- Lee los archivos project.promt.md y demás archivos .promt.md involucrados
- Actualiza los archivos de código del proyecto de acuerdo a Estándares de codificación
- Implementa las soluciones preventivas para errores comunes de PHPCS
- Implementa las soluciones preventivas para errores comunes de PSalm
- Implementa las soluciones preventivas para errores comunes de PHPStan

### Actualiza código
- Lee los archivos project.promt.md y demás archivos .promt.md involucrados
- Genera y actualiza los archivos de código del proyecto de acuerdo a los lineamientos funcionales, procesos, estructura
- Ejecutar "composer install" para descargar dependencias
- Ejecuta la tarea "Actualiza estandares"


### Actualiza promts
- Se han ejecutado una serie de cambios que se necesitan versionar en los archivos .promt.md
- Revisa los archivos project.promt.md y demás archivos .promt.md involucrados
- Genera versiones nuevas de los archivos .promt.md con los cambios realizados sin sobreescribir los originales

### Actualiza tareas
- Lee los archivos wordpress.promt.md
- Hay cambios en las tareas que se estarán pidiendo ejecutar
- Recuerda los cambios para evitar ejecutar tareas con instrucciones desactualizadas

### Verifica importante
- Lee los archivos project.promt.md y demás archivos .promt.md involucrados
- lista en el chat todos los puntos que dice IMPORTANTE
- Verifica que cumplas con cada punto

### Verifica inicio
- Verificar manualmente el entorno de desarrollo:
	- Verificar que PHP esté instalado localmente (versión 7.4 o superior) con `php -v`
	- Verificar que Composer esté instalado con `composer -v`
	- Si es necesario, crear un script de verificación temporal para verificar la instalación de PHP y Composer
	- IMPORTANTE: si creaste script de verificación temporal, Se elimine automáticamente después de su ejecución, no puede quedarse

### Verifica codigo
- obten los mensajes de error en la seccion "Problemas" de Visual Studio Code y corregir errores
- Ejecutar "composer install" para instalar las dependencias; resolver errores de compatibilidad
- Ejecutar "composer fix"
- Ejecutar "composer lint" y corregir errores
- Ejecutar "composer sca:psalm" y corregir errores
- Ejecutar "composer sca:phpstan" y corregir errores
- Ejecutar "composer analyze" para verificación final

### Levanta ambiente
- Ejecutar "composer docker:up"
- Accede a http://localhost:8080 despues de 1 minuto

### Verifica funcional
- Ejecutar la tarea "Levanta ambiente"
- Verifica que no hay errores en la consola de Docker (terminal)
- Verifica que cada servicio haya levantado adecuadamente de acuerdo a los tiempos que implementaste en los healhcheck configurados en el docker-compose.yml
	- si un servicio no levanto porque aun se esta aprovisionanado, necesitas ajustar valores start_period en los healcheck en docker-compose.yml y en la seccion "valores start_period para los servicios" de este documento
	- si los logs de algun servicio muestra algun error de configuración, necesitas avisarme para que revisemos que esta pasando
- si levantaron los servicios de manera adecuada, accede a http://localhost:8080 para verificar que WordPress y WooCommerce están funcionando correctamente
- IMPORTANTE: aunque muestre páginas, no deben mostrar errores PHP para tomar como válida la configuracion

---

## Solución de problemas comunes en wordpress

### Recordatorios importantes

1. **Solución de problemas con composer-git-hooks**:
   - Si encuentras el error "No hooks were added. Try updating", elimina el archivo cghooks.lock y usa la opción --force.

2. **Prevención de errores de PHPCS**:
   - Implementa las soluciones preventivas en lugar de corregir los errores después.
   - Asegúrate de seguir las convenciones de nomenclatura de WordPress.
   - Usa el prefijo del plugin para todas las funciones globales y nombres de hooks.

3. **Configuración de phpTools.json**:
   - Asegúrate de que la versión de PHP en phpTools.json coincida con la versión de PHP del proyecto

### Errores de PHPCS
- Para "Missing file doc comment": añadir comentarios de documentación
- Para "There must be no blank lines before the file comment": eliminar líneas en blanco o excluir regla
- Para "Inline comments must end in full-stops": añadir puntos finales
- Para "Line indented incorrectly": corregir indentación usando tabulaciones
- Para "The method parameter $i is never used": marcar con phpcs:ignore
- Para "Functions declared in the global namespace by a theme/plugin should start with the theme/plugin prefix": asegúrate de que todas las funciones globales tengan el prefijo del plugin
- Para "Hook names invoked by a theme/plugin should start with the theme/plugin prefix": usa el prefijo del plugin en los nombres de los hooks
- Para suprimir advertencias específicas, usa comentarios phpcs:ignore:
  ```php
  // phpcs:ignore WordPress.PHP.DevelopmentFunctions.error_log_debug_backtrace
  $trace = debug_backtrace( DEBUG_BACKTRACE_IGNORE_ARGS, 3 );

  // phpcs:ignore WordPress.PHP.DevelopmentFunctions.error_log_error_log
  error_log( $formatted_message, 3, $debug_file_path );
  ```

### Errores de PHPStan
- Para errores relacionados con tipos: añadir anotaciones de tipo en PHPDoc
- Para propiedades nunca leídas: añadir métodos getter
- Para errores de tipos en PHPDoc: configurar treatPhpDocTypesAsCertain: false
- Para métodos de clases desconocidas: añadir verificaciones is_object() y method_exists()
- Para errores de tipo incorrecto en esc_attr(): convertir explícitamente a string con (string)
- Para errores con clases de WordPress/WooCommerce: usar 'object' como tipo en PHPDoc, pero en la descripcion expecificar la clase original de WordPress/WooCommerce
- Para errores con métodos de clases de WordPress/WooCommerce: verificar si los stubs estan configurados en PHPStan y si el método existe

### Problemas específicos de plugins de pago para WooCommerce al levantar el ambiente de desarrollo
- Estos errores se presentan al Acceder a http://localhost:8080

#### Error "Class 'WC_Payment_Gateway_CC' not found"
- Este error puede ocurrir si WooCommerce no está completamente cargado cuando se intenta usar la clase `WC_Payment_Gateway_CC`.
- Solución: Modifica el archivo de la pasarela de pago para extender de `WC_Payment_Gateway` en lugar de `WC_Payment_Gateway_CC`.
- Alternativa: Asegúrate de que el plugin se carga después de que WooCommerce esté completamente inicializado usando el hook `plugins_loaded` con una prioridad adecuada.

#### Error "Call to undefined method WC_Payment_Gateway::credit_card_form()"
- Este error puede ocurrir si estás utilizando un método que no existe en la clase base.
- Solución: Implementa tu propio método `credit_card_form()` en la clase de la pasarela de pago.
- Asegúrate de que el método tenga la misma firma que el método en la clase padre o implementa tu propia lógica.

#### Error "Cannot redeclare class JsonSchema\Validator"
- Este error puede ocurrir si hay conflictos con otros plugins que utilizan la biblioteca JsonSchema.
- Solución: Utiliza un espacio de nombres personalizado para la biblioteca JsonSchema.
- Alternativa: Verifica si la clase ya está cargada antes de cargarla nuevamente usando `class_exists()`.

#### Error "Uncaught Error: Call to undefined function wc_get_template()"
- Este error puede ocurrir si WooCommerce no está completamente cargado cuando se intenta usar la función `wc_get_template()`.
- Solución: Asegúrate de que el plugin se carga después de que WooCommerce esté completamente inicializado.
- Alternativa: Implementa tu propia función para cargar plantillas si `wc_get_template()` no está disponible.

#### Error "Uncaught Error: Class 'WC_Logger' not found"
- Este error puede ocurrir si WooCommerce no está completamente cargado cuando se intenta usar la clase `WC_Logger`.
- Solución: Asegúrate de que el plugin se carga después de que WooCommerce esté completamente inicializado.
- Alternativa: Implementa tu propia función de registro si `WC_Logger` no está disponible.

#### Error "Uncaught Error: Class 'WP_Error' not found"
- Este error puede ocurrir si WordPress no está completamente cargado cuando se intenta usar la clase `WP_Error`.
- Solución: Asegúrate de que el plugin se carga después de que WordPress esté completamente inicializado.
- Alternativa: Implementa tu propia clase de error si `WP_Error` no está disponible.

#### El formulario de pago no se muestra
- Asegúrate de que has activado el método de pago en WooCommerce > Ajustes > Pagos.
- Verifica que el tema de WordPress es compatible con WooCommerce.
- Comprueba si hay conflictos con otros plugins de pago.
- Verifica que los scripts y estilos del formulario de pago se están cargando correctamente.
