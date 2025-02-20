# Solucion Prueba 3 - CI/CD



https://github.com/user-attachments/assets/1e55d044-1707-4b28-9130-aad8cfdfcf32



🎥 **Link del Drive con Demo->**  [P3_Demo](https://drive.google.com/file/d/1pA9BUw5aK_iCqz1TDx5vO9lPVm9fEIpT/view?usp=sharing)

### **✅ Solución:**  
- **Utilicé docker-compose** para generar y desplegar la imagen de **Nginx** en la misma **instancia EC2 creada por Terraform en la Consigna 2**.  
- **Configuré los secrets** en el repositorio para la conexión del pipeline con AWS.  
- **Usé GitHub Actions** para habilitar un pipeline que:  
  -  Detecta cambios solo en el `devops-interview-solutions/3prueba_solution/index.html`.  
  -  Se conecta a la instancia EC2 por **SSH**.  
  -  **Despliega automáticamente** los cambios tras un nuevo commit.  

---
## 🛠 Pre-requisitos
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Cuenta en GitHub sino la podes crear aca [Github_Register](https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home)
- Cuenta en AWS sino la podes crear aca [AWS_Register](https://signin.aws.amazon.com/signup?request_type=register)
- [AWS CLI](https://aws.amazon.com/cli/) configurado con credenciales válidas.
- Configuración de secrets en GitHub (EC2_IP, EC2_USER, EC2_SSH_KEY `.pem`).

## 🔧 Instalación y Configuración
1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/sergioortiz17/devops-interview-solutions.git
   ```
2. Configuración de GitHub Actions para que tengas acceso a la configuracion de los secrets. Podes hacer un fork de este repositorio o hacer una copia y publicarlo en tu Github de forma publica y asi tener tus propios secrets, fijate en el archivo de configuración en `.github/workflows/docker-ci.yml` con los mismos nombres de tus secrets para que GitHub Actions detecte cambios en `index.html` y ejecute el despliegue.
3. **Desplegar la instancia en tu cuenta AWS con Terraform**:
   - Configura tu archivo de variables para Terraform.
   - Ejecuta:
     ```bash
     cd devops-interview-solutions/terraform-ec2
     terraform init && terraform apply -auto-approve
     ```
4. **Actualizar secrets en tu GitHub**:
   - Una vez que la instancia esté desplegada, toma la IP y actualiza los secrets en la configuración del repositorio en GitHub:
     - `EC2_IP`: La IP de la instancia EC2.
     - `EC2_USER`: Usuario de acceso a la instancia.
     - `EC2_SSH_KEY`: Contenido del archivo `.pem` para SSH.

## 🚀Construcción y Despliegue
1. **Conectarse a la instancia via SSH**:
   ```bash
   ssh -i "mi-clave.pem" ubuntu@<IP_PUBLICA>
   ```
   Ejemplo:
   ```bash
   ssh -i /Users/sergioortiz/Desktop/DevOps/docker-compose.pem -o StrictHostKeyChecking=no ec2-user@107.22.81.78
   ```
2. **Ejecutar Docker Compose en la ubicacion `devops-interview-solutions/3prueba_solution`**:
    ```bash
   cd devops-interview-solutions/3prueba_solution
   ```
   ```bash
   docker-compose up --build -d
   ```
¡Listo! Ahora la aplicación está corriendo en AWS. 🚀
3. Para detener el contenedor (en la misma ubicacion dentro del EC2 devops-interview-solutions/3prueba_solution ):
  ```bash
  docker-compose down
  ```

## 📌 Uso
1. Ya desplegada la app poder verla en la web usando la URL http://<IP_PUBLICA>
2. Modifica el archivo `devops-interview-solutions/3prueba_solution/index.html`.
3. Realiza un commit y push al repositorio:
 Ejemplo:
   ```bash
   git add index.html
   git commit -m "Actualización de index.html"
   git push origin main
   ```
4. GitHub Actions ejecutará el pipeline y actualizará el despliegue automáticamente.
5. Actualiza la web http://<IP_PUBLICA> y ya deberias ver el cambio

---
## Referencias
- [Curso DevOps 2022 - Clase 5 - CI/CD](https://youtu.be/Nz5FkiTH4iY?list=PLnf4-vBnJ1n323-UT2TZzj9gzahf_VhTF&t=7)
