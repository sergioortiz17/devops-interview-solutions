# **Solución de Prueba Técnica – Craftech🚀**  
### _Postulación para DevOps Trainee – Sergio Ortiz_ 

![ezgif com-gif-to-mp4-converter](https://github.com/user-attachments/assets/3fab99d1-fe32-4e86-8570-3093c74730d8)
---

## **Consigna Prueba 1 - Diagrama de Red**
📍 Produzca un diagrama de red (puede utilizar Lucidchart) de una aplicación web en GCP o AWS y escriba una descripción de texto de ½ a 1 página explicando sus elecciones y arquitectura. El diseño debe soportar:
- Cargas variables  
- Alta disponibilidad (HA)  
- Frontend en JavaScript  
- Backend con una base de datos relacional y una no relacional  
- El backend consume dos microservicios externos  

📌 _El diagrama debe hacer un mejor uso de las soluciones distribuidas._  
### **✅ Solución:**  
![image](https://github.com/user-attachments/assets/a246e700-fbf1-433d-bfbe-a304b90ef176)


🔗 **📄 Descripción completa del diagrama aquí ->** [README_P1](https://github.com/sergioortiz17/devops-interview-solutions/tree/main/1prueba_solution#readme)

---

## **Consigna Prueba 2 - Despliegue de una aplicación Django y React.js**  
📍 Elaborar el *deployment* dockerizado de una aplicación en **Django (backend)** con **React.js (frontend)** contenida en el repositorio.  

📌 **Requisitos:**  
- Todos los servicios deben desplegarse en un solo **docker-compose**.  
- Entregar los **Dockerfiles** necesarios y justificar la estrategia utilizada (*supervisor, scripts, docker-compose, Kubernetes, etc.*).  
- Subir el código de la aplicación a un repositorio (**GitHub, GitLab, Bitbucket, etc.**) incluyendo un **README.md** con instrucciones detalladas para compilar y desplegar la aplicación en **una PC local y en la nube (AWS o GCP).**  

### **✅ Solución:**  
- Utilicé docker-compose para desplegar Dockerfiles con **multistage** para optimizar la imagen tanto en local como en AWS.  
- **Usé Terraform** para crear instancias EC2 automáticamente, configurando su **Security Group** y la clave SSH.  
- Terraform ejecuta un **script** que:  
  -  Instala **Git, Docker y Docker Compose**  
  -  Clona el repositorio  
  -  Captura la **IP pública de la instancia** y la asigna como **variable de entorno**  
- Esto permite que el **frontend pueda hacer solicitudes** y el **backend recibirlas correctamente**, evitando problemas de **CORS**.  

🔗 **📄 Detalle completo de la implementación aquí ->** [README_P2](https://github.com/sergioortiz17/devops-interview-solutions/tree/main/2prueba_solution#readme)

🎥 **Link del Drive con Demo->**  [P2_Demo](https://drive.google.com/file/d/1pOTtSG3o77Xwe8CsJbKS6EoazKq1UI0K/view?usp=sharing)

---

## **Consigna Prueba 3 - CI/CD** 
📍 Dockerizar **Nginx** con el `index.html` por defecto y elaborar un **pipeline** que:  
-  Detecte cambios en `index.html`.  
-  Construya la nueva imagen y la **actualice en la plataforma elegida** (*Docker Compose, Swarm, Kubernetes, etc.*).  
-  Permita el uso de **CircleCI, GitLab, GitHub Actions o Bitbucket** para la creación del pipeline.  

### **✅ Solución:**  
- **Utilicé docker-compose** para generar y desplegar la imagen de **Nginx** en la misma **instancia EC2 creada por Terraform en la Consigna 2**.  
- **Configuré los secrets** en el repositorio para la conexión del pipeline con AWS.  
- **Usé GitHub Actions** para habilitar un pipeline que:  
  -  Detecta cambios solo en el `devops-interview-solutions/3prueba_solution/index.html`.  
  -  Se conecta a la instancia EC2 por **SSH**.  
  -  **Despliega automáticamente** los cambios tras un nuevo commit.  

🔗 **📄 Detalle completo de la implementación aquí ->** [README_P3](https://github.com/sergioortiz17/devops-interview-solutions/tree/main/3prueba_solution#readme)

🎥 **Link del Drive con Demo->**  [P3_Demo](https://drive.google.com/file/d/1pA9BUw5aK_iCqz1TDx5vO9lPVm9fEIpT/view?usp=sharing)
