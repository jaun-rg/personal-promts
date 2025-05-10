genera un diagrama de arquitectura en draw.io con lo siguiente:
- nombre: architecture
- ubicacion: docs/diagrams/architecture/
- formato: png editable por draw.io  

- un bloque general llamado "Extelnal services" donde esten todos los servicios que no son de aws
  - github
- un bloque "aws cloud" que contenga todo lo de aws
  - 2 regiones
      - us-east-1
      - us-west-2
  - en cada region
    - bloque vpc con public y private subnets
      - 1 ec2 con terraform, ansible y el cual sera un jenkins esclavo (slave), asociado a los demas ec2 y a s3
      - 1 ec2 con node
      - 1 ec2 con java
    - bloque general llamado "services" con un s3 bucket
  - solo en us-east-1
    - 1 ec2 con jenkins que sea maestro en la subnet privada
      - este ec2 se conecta a los esclavos de ambas regiones
      - este esclavo se conecta a github, el cual es un servicio fuera de aws
      - se necesita representar que un job de jenkins se puede ejecutar manualmente o por un cambio en la rama main del repo de github
  - un bloque general llamado  "global services" con 
    - un cloudfront asociado a jenkins master
    - route 53 asociado a cloudfront y con host jenkins.patito.com

- adicionales
  - todas las etiquetas y textos en inglés
  - necesito representar que jenkins master se conecte a los esclavos de ambas regiones agrega todo los elementos faltantes para representar esta conexion
  - si hay mas elemento de red con internet gateways y asociaciones, agregalas
  - si consideras que hacen falta servicios tanto internos como externos, agregalos

- este diagrama es una representación de la arquitectura en donde se ejecutará este proyecto

- genera {ubicacion}/{nombre}.promt.md en formato markdown para que puedas regenerar el diagrama con todos los requerimientos antes mencionados
