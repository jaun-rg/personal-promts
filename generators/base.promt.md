# Prompt Base para Inicialización de Proyectos

Este documento proporciona un prompt base para generar archivos de inicialización de proyectos para varios tipos de proyectos. Cada tipo de proyecto tendrá su propio archivo prompt, que se utilizará para crear la estructura y configuración del proyecto.

## Instrucciones

Para cada tipo de proyecto en la lista a continuación, genera un archivo prompt llamado {name}.promt.md.

Cada archivo prompt debe:
- Ser parametrizable para generar un proyecto con el nombre de carpeta {name} de forma recursiva.
- Usar el valor predeterminado {name} si no se pasa ningún parámetro.
- Crear subdirectorios de forma recursiva si {name} contiene /.
- Incluir un archivo README.md con las siguientes secciones:
  - Descripción: Una breve descripción del proyecto.
  - Estructura: Estructura de directorios del proyecto.
  - Dependencias: Lista de dependencias.
  - Instalación: Comandos para instalar herramientas necesarias.
  - Ejecución: Instrucciones para ejecutar el proyecto.
  - Anexo: Referencias para consultar.
- Agregar código base o de ejemplo en la carpeta del proyecto, preferiblemente como parte de la plantilla Copier.
- Configurar .gitignore y usar gestores de paquetes para instalar dependencias del proyecto.
- Usar Copier para generar el proyecto (consultar https://copier.readthedocs.io/en/stable/#basic-concepts).
- Configurar pre-commit o herramientas similares para análisis de código, verificaciones de calidad y escaneo de vulnerabilidades usando hooks de Git.
- Detectar y resolver errores automáticamente cuando sea posible.

Después de generar cada archivo {name}.promt.md, ejecútalo para crear el proyecto.

Inicializa un repositorio Git en el directorio del proyecto generado y realiza un commit inicial.

## Lista de Proyectos

terraform: Infraestructura con Terraform dividida en módulos con soporte para múltiples entornos y regiones. Incluye un archivo tfvars general y uno para cada módulo. Requiere al menos dos archivos tfvars para la ejecución.

pipeline/aws/lambda: Pipelines de AWS y CodeDeploy para desplegar proyectos Lambda. Incluye opciones de despliegue blue/green y canary.

pipeline/aws/eks: Pipelines de AWS y CodeDeploy para desplegar proyectos EKS. Incluye la construcción del proyecto, generación de imagen, almacenamiento en ECR y despliegue en EKS. Soporta opciones de despliegue blue/green y canary.

eks/base: Manifiestos de Kubernetes para despliegue, ingress, servicios y secretos basados en EKS.

eks/kustomize: Manifiestos de Kubernetes para despliegue, ingress, servicios y secretos para múltiples entornos y configuraciones usando Kustomize.

eks/argocd: Manifiestos de Kubernetes para despliegue, ingress, servicios y secretos usando ArgoCD.

projects/java: Proyectos de API con Java usando Spring/Spring Boot, incluyendo pruebas unitarias, autenticación y seguridad.

projects/python: Proyectos de API con Python, incluyendo pruebas unitarias, autenticación y seguridad.

projects/node: Proyectos de API con Node.js, incluyendo pruebas unitarias, autenticación y seguridad.

projects/loopback: Proyectos de API con LoopBack, incluyendo pruebas unitarias, autenticación y seguridad.

## Notas Adicionales

Cada proyecto generado debe incluir un archivo README.md con instrucciones detalladas y referencias.

Usa Git para inicializar el repositorio y realizar un commit inicial después de generar el proyecto.
