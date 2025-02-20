# Solucion Prueba 2 - Despliegue de una aplicación Django y React.js

![awsP2_demo](https://github.com/user-attachments/assets/80c14f10-014e-4707-bd75-d8b0ad2761b1)

🎥 **Link del Drive con Demo->**  [P2_Demo](https://drive.google.com/file/d/1pOTtSG3o77Xwe8CsJbKS6EoazKq1UI0K/view?usp=sharing)

### **✅ Solución:**  
- Utilicé docker-compose para desplegar Dockerfiles con **multistage** para optimizar la imagen tanto en local como en AWS.  
- **Usé Terraform** para crear instancias EC2 automáticamente, configurando su **Security Group** y la clave SSH.  
- Terraform ejecuta un **script** que:  
  -  Instala **Git, Docker y Docker Compose**  
  -  Clona el repositorio  
  -  Captura la **IP pública de la instancia** y la asigna como **variable de entorno**  
- Esto permite que el **frontend pueda hacer solicitudes** y el **backend recibirlas correctamente**, evitando problemas de **CORS**.

### ¿Por qué usar Dockerfiles con Multi-Staging?
El Dockerfile del Frontend y el Dockerfile del Backend utilizan multi-staging para optimizar la imagen del contenedor, reduciendo su tamaño y mejorando el tiempo de ejecución.

- Imagen sin Multistage:
![image](https://github.com/user-attachments/assets/9bc06a41-3647-4004-99ae-91e1ea58ce1e)

- Imagen con Multistage local:
![image](https://github.com/user-attachments/assets/44351398-e4df-4635-b5bd-b1c6603ee611)
- Imagen con Multistage en EC2 AWS:
![image](https://github.com/user-attachments/assets/fe66bf78-33cc-4de4-b639-8bf0ec5fcebf)


| Servicio  | Tamaño Original (MB) | Tamaño Optimizado (MB) | % Optimización |
|-----------|----------------------|------------------------|----------------|
| Frontend  | 622                  | 57.6                   | 90.74%         |
| Backend   | 1050                 | 110                    | 89.52%         |

Para el despliegue en una instancia EC2 de AWS, el uso de Multi-Staging fue clave. Las instancias dentro del nivel gratuito de AWS suelen tener un máximo de 1GB de almacenamiento, por lo que, sin optimización, la imagen superaba este límite y hacía que la instancia dejara de funcionar.

---

#  Despliegue Local con Docker Compose
📌 Este proyecto utiliza Docker Compose para gestionar y ejecutar múltiples contenedores de manera sencilla en un entorno de desarrollo local.

## 🛠 Prerrequisitos
Antes de comenzar, asegúrate de tener instalados los siguientes requisitos:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## 🚀 Instalación
1. Clona este repositorio e ingresa a la ubicacion devops-interview-solutions/2prueba_solution:
   ```bash
   git clone https://github.com/sergioortiz17/devops-interview-solutions.git
   ```
   ```bash
   cd devops-interview-solutions/2prueba_solution
   ```
2. Construye y levanta los contenedores con Docker Compose:
   ```bash
   docker-compose up --build -d
   ```

## 📌 Uso
- El frontend de la aplicación estará disponible en `http://localhost:3000`.
- El backend de la aplicación estará disponible en `http://localhost:8000`.
- Para detener los contenedores (en la misma ubicacion devops-interview-solutions/2prueba_solution ):
  ```bash
  docker-compose down
  ```
---

# Despliegue en AWS con Terraform
📌 Este despliegue usa Terraform para provisionar una instancia EC2 en AWS y desplegar la aplicación de manera automatizada.
OBS: Lo podes hacer sin Terraform creando la instancia EC2 manualmente

## 🛠 Prerrequisitos
Antes de ejecutar Terraform, asegúrate de tener:
- Cuenta en AWS sino la podes crear aca [AWS_Register](https://signin.aws.amazon.com/signup?request_type=register)
- Logueate en aws y crea una clave SSH propia para conectarte a tus instancias.
- [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado.
- [AWS CLI](https://aws.amazon.com/cli/) configurado con credenciales válidas.

## 🔧 Configuración
1. Configura las credenciales de AWS:
   ```bash
   aws configure
   ```
2. Clona este repositorio en tu local y ve a `devops-interview-solutions/terraform-ec2`:
   ```bash
   git clone https://github.com/sergioortiz17/devops-interview-solutions.git
   cd devops-interview-solutions/terraform-ec2
   ```
3. Modifica `devops-interview-solutions/terraform-ec2/main.tf` con el nombre de tu key ssh creada previamente en aws.
4. Modifica `devops-interview-solutions/terraform-ec2/main.tf` con el nombre que quieras darle a tu instancia EC2.

## 🚀 Despliegue con Terraform
1. Una vez clonado localmente el repo ve a `devops-interview-solutions/terraform-ec2` e Inicializa Terraform:
   ```bash
   terraform init && terraform apply -auto-approve
   ```
2. Una vez creado el EC2, Terraform mostrará la IP pública. Usa esta IP para conectar vía SSH:
   ```bash
   ssh -i "mi-clave.pem" ubuntu@<IP_PUBLICA>
   ```
   Ejemplo:
   ```bash
   ssh -i /Users/sergioortiz/Desktop/DevOps/docker-compose.pem -o StrictHostKeyChecking=no ec2-user@107.22.81.78
   ```
3. Dentro ya encontraras clonado el repositorio y las variables de entorno seteadas con la ip publica, solo ve a la ubicacion
      ```bash
   cd devops-interview-solutions/2prueba_solution
   ```
4. Construye y levanta los contenedores con Docker Compose:
   ```bash
   docker-compose up --build -d
   ```
¡Listo! Ahora la aplicación está corriendo en AWS. 🚀

## 📌 Uso
- El frontend de la aplicación estará disponible en `http://<IP_PUBLICA>:3000`.
- El backend de la aplicación estará disponible en `http://<IP_PUBLICA>:8000`.
- Para detener los contenedores (en la misma ubicacion dentro del EC2 devops-interview-solutions/2prueba_solution ):
  ```bash
  docker-compose down
  ```
## 📌 Post-Deployment
- Para destruir los recursos creados, desde tu repositorio local en `devops-interview-solutions/terraform-ec2`:
  ```bash
  terraform destroy -auto-approve
  ```
## OBS: Configuración Automática de la Aplicación 
En el paso 3 del Despliegue con Terraform
- Terraform capturará la IP pública de la instancia y generará un archivo `.env` para el frontend y backend.
- El front que usaba una constante aca devops-interview-solutions/2prueba_solution/frontend/src/config/constant.js ahora usa la ip publica generada
- El back que solo recibia requests de  `http://localhost:3000` aca devops-interview-solutions/2prueba_solution/backend/core/settings.py ahora acepta tambien requests de `http://<IP_PUBLICA>:3000` que se la paso por el docker-compose
- Esto previene problemas de CORS y asegura la correcta comunicación entre servicios.


---
## Referencias 
- Docker Multistage [Curso DevOps 2022 - Clase 2 - Docker](https://youtu.be/EkJXacEKNpA?t=5829)
- Repositorio ejemplo de multistage [golang-sample-app](https://github.com/codefresh-contrib/golang-sample-app/blob/master/Dockerfile.multistage)
