# Contenido original de: woocommerce-plugins/ravent-payments-gateway/project.promt.md
# Creado automáticamente por update_promts.sh
# 2025-05-06 18:45:34

# Especificación del plugin Ravent Payments Gateway

Este documento describe las características específicas del plugin Variant Photo Gallery para WooCommerce.

**IMPORTANTE**: Este plugin debe implementarse siguiendo todas las directrices generales definidas en el archivo [wordpress.promt.md](../wordpress.promt.md).

## Información general

- Nombre del plugin: Ravent Payments Gateway
- Text domain: 'ravent-payments-gateway'
- Prefijos permitidos (incluyendo para funciones globales): ravent_payments_gateway, Ravent_Payments_Gateway
- la carpeta actual es la raiz del proyecto

## Funcionalidad principal

El plugin permite pagar mediante el api de Ravent pedidos (checkout) de woocomerce

### Administración del plugin

#### Caracteristicas generales
- La funcionalidad está asociada a la sección Payments del menú de Woocomerce
- URL del api:
  - Ravent Api URL : https://ravent.com/api/
  - Ravent Test Api URL : https://test.ravent.com/api/
- Solicitudes de pago:
  - Si Test Mode esta habilitado: usa Ravent Test Api URL y Ravent Test Api Token;
  - Si Test Mode esta deshabilitado: usa Ravent Api URL y Ravent Api Token
  - se debe contar con json schema para validar los datos a enviar al api de ravent
    - instala las dependencias necesarias
  - se debe registrar en wordpress/woocomerce status de pago asi como el response de ravent  
- Modo Debug:
  - Genera una clase que maneje los logs del plugin y que sea usado en las demas clases 
    - el tipo de log por defecto debe ser INFO
    - debe poderse identificar el plugin y la clase
  - Si Debug Mode esta habilitado: guarda los mensajes de este plugin hasta nivel DEBUG en el log de woocommerce y en Debug File Path pero ofusca la información delicada por temas de cumplimiento pero de forma que pueda darse un seguimiento
  - Si Debug Mode esta deshabilitado: guarda los mensajes de este plugin hasta nivel INFO solo en el log de woocommerce


#### Página de ajustes
- Accesible desde el administrador de plugins (enlace "Ajustes")
- Opciones configurables:
  - Modo Debug: checkbox (enable/disable)
  - Debug File Path: string (deshabilitado para edición si Modo Debug está deshabilitado; valor por defecto: /var/log/ravent-payments-gateway.log)
  - Test Mode : checkbox  (enable/disable)
  - Ravent Api Token : string
  - Ravent Test Api Token : string (deshabilitado para edición si test mode está deshabilitado)
- Botón para guardar las configuraciones en la base de datos


### Frontend

#### Visualización en la página de checkout
- debe aparecer el método de pago habilitado
- debe aparecer los campos de tarjeta de crédito usales 
- debe hacer validaciones de datos sobre los campos de tarjeta de crédito
- debe mostrar un spinner mientras espera la respuesta de Ravent o se produce un timeout 
- mostrar notificaciones de estado correspondiente  
- Toma en consideración que puede ser el único método de pago habilitado, por lo que no se debe presentar el mensaje de checkout vacio
- Puede coexistir con otros métodos de pago

### Internacionalización
- soporte para español, ingles, frances y aleman

## Ambiente de pruebas específico

### Configuración del ambiente de pruebas
- Instala y habilita el plugin que estamos generando
- Genera un producto de prueba si no existe
- Genera un cliente de prueba si no existe
- inicia una sesion con el usuario y agrega el producto
