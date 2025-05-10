# Especificación del plugin

Este documento describe las características específicas de un plugin para WooCommerce.

IMPORTANTE: SIEMPRE que examines este archivo, necesitas examinar el archivo ../wordpress.promt.md

## Información general

- Nombre del plugin: Ravent Save Order Checkout
- Descripcion: plugin de woocomerce para enviar la informacion de pedido como una orden a Ravent y actualiza el estado
- version: 1.0.0

- repositorio: git@github.com:jaun-rg/wp-plugins-ravent-save-order-checkout.git
- la carpeta actual es la raiz del proyecto
- IMPORTANTE: version de php: 8.3.20

## Funcionalidad principal

### Caracteristicas generales
- se debe contar con json schema para validar los datos de los request, los response y para los datos de la ordenes de woocomerce y Ravent
  - Genera una carpeta includes/utils/schemas/ donde guardes todos los json schema
  - instala las dependencias necesarias para json schema
- necesitas ransformar/parsear entre modelos/esquemas/objetos, por ejemplo, transformar una orden de woocommerce a la estructura de orden de Ravent
  - genera una carpeta includes/utils/parsers/ donde guardes clases para hacer las transformaciones/parseos
- URL del api (no editable y no visible en la administracion):
  - Ravent Api URL : https://ravent.com (para produccion)
  - Ravent Test Api URL : https://test.ravent.com (para prueba)
- Internacionalización: soporte para español, ingles, frances y aleman
- IMPORTANTE: woocomerce muestra un mensaje de error por defecto cuando no hay un método de pago habilitado, si este plugin esta habilitado, el mensaje mencionado se debe deshabilitar
- puede convivir con otros métodos de pago

### Endpoints del Api de Ravent
- cada uno tiene que tener un json schema para validar el request y el response
- cada uno debe ser implementado en un método independiente
- para tranformar datos de Woocommerce a Ravent y viceversa, se debe usar los parsers mencionados anteriormente

#### Obtener token de autenticación
- request:
	- metodo: GET
	- url: {API URL}/api/auth
	- headers :
		- client id:  CLIENT ID
		- token : AUTH TOKEN
	- body: (vacio, tipo: url-encoded)
- response :
	- expected http status:
		- SUCCESS: 200
	- body: (tipo: json)
	- token: token de autenticación para ravent (ACCESS TOKEN)
	- expiration: numero de segundos que dura el ACCESS TOKEN

#### Crear orden
- request:
- tipo: POST
- url: {API URL}/api/order
- headers:
	- client id:  CLIENT ID
	- token : ACCESS TOKEN
- body: (tipo: json)
	- wp_order_id: id del pedido en woocomerce
	- order: todos los datos del pedido
	- customer: todos los datos del cliente
- response:
- expected http status:
	- SUCCESS: 200, 201
- body: (tipo : json)
	- order_id: id de la orden en ravent
	- wp_order_id: id del pedido en woocomerce
	- status: estado de la orden en ravent (SUCCESS / ERROR)
	- message: solo en caso de status sea ERROR y contiene el mensaje de detalle presentado
	- created_at: fecha de creacion de la orden en ravent (formato ISO 8601)

#### Actualizar orden
- request:
- tipo: PUT
- url: {API URL}/api/order
- headers:
	- client id:  CLIENT ID
	- token : ACCESS TOKEN
- body: (tipo: json)
	- order_id: id de la orden en ravent
	- wp_order_id: id del pedido en woocomerce
	- order: todos los datos del pedido
	- customer: todos los datos del cliente
- response:
- expected http status:
	- SUCCESS: 200, 201
- body: (tipo : json)
	- order_id: id de la orden en ravent
	- wp_order_id: id del pedido en woocomerce
	- status: estado de la orden en ravent (SUCCESS / ERROR)
	- message: solo en caso de status sea ERROR y contiene el mensaje de detalle presentado
	- created_at: fecha de creacion de la orden en ravent (formato ISO 8601)

### Proceso Ravent Save Order
- Revisa si hay un ACCESS TOKEN valido y no ha expirado, si no, solicita uno nuevo y lo guarda en la base de datos
  - para la expiracion necesita calcula y guardar fecha y hora de expiracion
  - para solicitar un ACCESS TOKEN se envia peticion : Obtener token de autenticación
- Revisa si el pedido ya tiene asociado un Ravent Order ID
  - si tiene un un Ravent Order ID,
    - transforma la orden de woocomerce a la estructura para Actualizar orden de Ravent ya que requiere el Ravent Order ID,
    - actualiza la orden mediante la peticion : Actualizar orden
  - si no tiene un un Ravent Order ID,
    - transforma una orden de woocomerce a la estructura para Crear orden de Ravent
    - crea la orden mediante la peticion : Crear orden
- si alguna peticion devuelve el status distinto a SUCCESS, ese debe actualizar el estado del pedido/carrito a ERROR
  - agregar en notas del pedido una nota:
      Se presenta error, favor de Reenviar a Ravent. mensaje {message}
- si el status de Crear la orden es SUCCESS: se debe actualizar el estado del pedido/carrito a EN ESPERA
  - agregar en notas del pedido una nota:
      Se envia a Ravent. Ravent Order ID: {order_id}
- un pedido puede enviarse varias veces a Ravent, por ello es importante guardar Ravent Order ID la informacion de cada respuesta

## Paginas administrativas

### Página de cada pedido
- En acciones de pedido debe aparecer una nueva opcion para ejecuta Proceso Ravent Save Order : Enviar a Ravent
- debe ser posible ejecutarla multiples veces, por ello es importante guardar Ravent Order ID
- El pedido debe mostrar en una seccion llamada Ravent:
  - order_id: id de la orden en ravent
  - cada created_at, status y message asociado al order_id

### Página de administracion de plugins
- Debe de haber un enlace en el administrador de plugins llamado "Ajustes" que lleve a la Página de ajustes

### Página de ajustes
- La funcionalidad debe estar asociada a Ravent -> Ajustes
  - Ravent: estos datos lo comparten todos los plugins de Ravent, por lo que es importante no duplicar estos campos si ya existe un plugin de Ravent instalado
    - Ravent Api Token : string
    - Ravent Client ID : string
    - Ravent Test Api Token : string (deshabilitado para edición si test mode está deshabilitado)
  - Save order Checkout: estas opciones deben estar en una seccion adicional en la misma página y solo aplican para este plugin
    - Modo Debug: checkbox (enable/disable)
    - Debug File Path: string (deshabilitado para edición si Modo Debug está deshabilitado; valor por defecto: /var/log/{Text domain}.log)
    - Test Mode : checkbox  (enable/disable)
  - Botón para guardar las configuraciones en la base de datos

#### Modos de operacion
- Modo de prueba:
    - El modo de prueba te permite probar pagos, reembolsos, disputas y otros procesos similares
    - Si Test Mode esta habilitado:
      - API URL:  Ravent Test Api URL
      - CLIENT ID: Ravent Test Client ID
      - AUTH TOKEN: Ravent Test Api Token
    - Si Test Mode esta deshabilitado
      - API URL:  Ravent Api URL
      - CLIENT ID: Ravent Client ID
      - AUTH TOKEN: Ravent Api Token
- Modo Debug:
  - Genera una clase que maneje los logs del plugin y que sea usado en las demas clases
    - el tipo de log por defecto debe ser INFO
    - debe poderse identificar el plugin y la clase
  - Si Debug Mode esta habilitado: guarda los mensajes de este plugin hasta nivel DEBUG en el log de woocommerce y en Debug File Path pero ofusca la información delicada por temas de cumplimiento pero de forma que pueda darse un seguimiento
  - Si Debug Mode esta deshabilitado: guarda los mensajes de este plugin hasta nivel INFO solo en el log de woocommerce


## Páginas de cliente

### Página de checkout
- Si el plugin esta habilitado, debe aparecer el un boton como si fuera un metodo de pago express con el texto "Enviar a Ravent y Finalizar pedido"
  - ejecuta el Proceso de Ravent Payment al dar click en el boton
- debe mostrar un spinner mientras espera la respuesta de Ravent o despues de un timeout de 1 minuto
- finaliza el pedido y redirige al usuario a la pagina de confirmacion de pedido
- debe mostrar notificaciones de estado correspondiente

## Ambiente de pruebas específico

### Configuración del ambiente de pruebas
- Instala y habilita el plugin que estamos generando
- Genera un producto de prueba si no existe
- Genera un cliente de prueba si no existe
- inicia una sesion con el usuario y agrega el producto a un carrito

### Mockup del Api de Ravent
- hay que generar un mockup interceptor (eso quiere decir que si envio una peticion a https://ravent.com/api/{algo} o https://test.ravent.com/api/{algo}, el mockup debe interceptarla y devolver la respuesta predefinida)
  - interceptar las peticiones al Api de Ravet y devolver las respuestas predefinidas
  - usa aksoyih/http-mock para generar el mockup
  - IMPORTANTE: el mockup debe interceptar las peticiones de todos los endpoints de Endpoints del Api de Ravent
  - el mockup se debe poder:
    - habilitar: si se habilita, todas las peticiones al Api de Ravent debe responderlas este mockup
    - deshabilitar: las peticiones no se interceptan y se envian directo al Api de Ravent
  - Genera un archivo MOCKUP.md con la documentacion para
    - habilitar y deshabilitar
    - eliminar el mockup
