# Solucion Prueba 1 - Diagrama de Red

![Diagrama_Craftech](https://github.com/user-attachments/assets/49dea769-18ac-4cca-b7b2-c8c0c84d61e4)

### **✅ Solución:**  
- Segui la sugerencia de usar LucidChart tiene plantillas y los iconos oficiales de AWS, y tiene 7 dias de free trial.
- Me guie usando la siguiente documentacion:
  - AWS [web-application-hosting-best-practices](https://docs.aws.amazon.com/es_es/whitepapers/latest/web-application-hosting-best-practices/an-aws-cloud-architecture-for-web-hosting.html)
  - AWS [Arquitectura](https://docs.aws.amazon.com/es_es/whitepapers/latest/how-aws-pricing-works/architecture.html)
  - CISCO [Seguridad](https://gblogs.cisco.com/la/sg-gdreibij-seguridad-en-la-nube-para-aws/)

## 📌 Requisitos y Justificación del Diseño  

### ✅ 1. Soporte para Cargas Variables  
✔ **Justificación:**  
- Se implementó **Auto Scaling** en los servidores Web y App, lo que permite aumentar o reducir la cantidad de instancias EC2 según la demanda.  
- Se usa **Elastic Load Balancer (ELB)** para distribuir el tráfico de manera eficiente entre los servidores web.  
- **Amazon API Gateway** permite gestionar múltiples solicitudes de manera eficiente y sin necesidad de administrar servidores adicionales.  
- **DynamoDB** maneja tráfico variable automáticamente gracias a su escalabilidad horizontal sin configuración manual.  

---

### ✅ 2. Alta Disponibilidad (HA - High Availability)  
✔ **Justificación:**  
- **Las instancias EC2 están distribuidas en múltiples zonas de disponibilidad (AZs)** dentro de una VPC, lo que garantiza que la aplicación siga funcionando si una AZ falla.  
- **RDS Multi-AZ** proporciona replicación automática y failover en caso de caída de la base de datos principal.  
- **DynamoDB tiene replicación global**, asegurando acceso a los datos en diferentes regiones.  
- **AWS CloudFront** mejora la disponibilidad y velocidad del contenido estático para usuarios globales.  
- **Amazon S3 almacena archivos estáticos con redundancia automática y alta disponibilidad.**  
- **NAT Gateway y VPC bien configurados** permiten acceso controlado a Internet sin exponer instancias privadas.  

---

### ✅ 3. Frontend en JavaScript  
✔ **Justificación:**  
- **CloudFront** sirve como **CDN para entregar contenido estático (React, Angular, Vue, etc.) con baja latencia**.  
- **Amazon S3 almacena y distribuye archivos estáticos del frontend** de manera eficiente.  
- **API Gateway facilita la conexión entre el frontend y los servicios backend.**  
- **AWS WAF protege las solicitudes entrantes de ataques comunes como XSS y SQL Injection.**  

---

### ✅ 4. Backend con Base de Datos Relacional y No Relacional  
✔ **Justificación:**  
- Se implementó **Amazon RDS (MySQL/PostgreSQL) con Multi-AZ**, asegurando una base de datos relacional para manejar transacciones críticas.  
- **Amazon DynamoDB maneja datos NoSQL**, ideal para almacenar información que necesita escalabilidad rápida (logs, sesiones, etc.).  
- **Ambas bases de datos están en subnets privadas** para mayor seguridad, sin acceso directo desde Internet.  
- **El backend (App Servers) está en subnets privadas y solo accede a RDS y DynamoDB a través de Security Groups bien configurados.**  

---

### ✅ 5. Backend consume 2 Microservicios Externos  
✔ **Justificación:**  
- **Amazon API Gateway facilita la comunicación con los microservicios externos, asegurando autenticación y control de tráfico.**  
- **AWS Lambda se puede usar para integraciones ligeras sin necesidad de servidores adicionales.**  
- **El NAT Gateway permite que los servidores privados accedan a los microservicios externos sin exponer sus IPs.**  
- **CloudWatch monitorea el tráfico y permite detectar posibles problemas en la comunicación con los servicios externos.**  

---

### ✅ 6. Mejor uso de Soluciones Distribuidas  
✔ **Justificación:**  
- **CloudFront mejora el rendimiento de distribución de contenido globalmente.**  
- **API Gateway desacopla el frontend del backend, permitiendo mejor escalabilidad.**  
- **RDS Multi-AZ y DynamoDB garantizan disponibilidad y replicación distribuida.**  
- **Auto Scaling permite escalar dinámicamente los servidores según la demanda.**  
- **Uso de S3 para almacenamiento estático en lugar de depender de servidores EC2.**  
- **Lambda permite ejecutar código sin necesidad de instancias EC2 dedicadas.**  

---

### Adicionalmente  

1️⃣ Amazon Route 53
Resuelve nombres de dominio (DNS), traduciendo dominios a direcciones IP.
Usa enrutamiento basado en latencia, dirigiendo a los usuarios a la región de AWS más cercana para optimizar el tiempo de respuesta y mejorar la experiencia del usuario.

2️⃣ AWS Shield
Protege contra ataques de denegación de servicio distribuido (DDoS) de forma automática.
Mitigación activa, detectando y bloqueando tráfico malicioso antes de que afecte los servidores.
Si se usa Shield Advanced, se obtiene protección avanzada con soporte 24/7 y visibilidad en tiempo real.

3️⃣ AWS WAF (Web Application Firewall)
Filtra y bloquea tráfico malicioso, protegiendo contra inyecciones SQL, ataques de XSS (cross-site scripting), y otras amenazas web.
Define reglas personalizadas para controlar qué tráfico es permitido o bloqueado.

4️⃣ Amazon Cognito
Autentica y gestiona usuarios, permitiendo login con credenciales tradicionales o con proveedores externos (Google, Facebook, Apple, etc.).
Maneja tokens de sesión y control de acceso a la API de forma segura.
Soporta MFA (autenticación multifactor) y políticas de contraseñas.

5️⃣ Amazon API Gateway + CloudWatch + Grafana
API Gateway:
Expone endpoints RESTful o WebSocket, gestionando tráfico y seguridad de las APIs.
Maneja limitaciones de solicitudes (throttling) y autenticación con Cognito o IAM.
CloudWatch:
Captura logs de tráfico, errores y métricas del API Gateway.
Permite alertas y monitoreo en tiempo real.
Grafana:
Analiza los logs de CloudWatch con dashboards visuales para entender tráfico, errores y rendimiento.

6️⃣ AWS Certificate Manager (ACM)
Gestiona certificados SSL/TLS de forma automática para cifrar la comunicación entre el usuario y la aplicación.
Renovación automática, evitando expiraciones de certificados y fallas en la seguridad.

7️⃣ AWS Secrets Manager
Almacena credenciales, claves API y contraseñas de forma segura.
Automatiza la rotación de credenciales, reduciendo riesgos de exposición.
Se integra con RDS, API Gateway, Lambda y otros servicios para gestionar acceso seguro sin exponer secretos en el código.

8️⃣A cada subnet dentro de la VPC le deje definido un rango de direcciones IP  CIDR (Classless Inter-Domain Routing) de 256 ips cada subnet Ejemplo: 10.0.0.0/24 abarca las direcciones 10.0.0.0 → 10.0.0.255
y 10.0.1.0/24 abarca las direcciones 10.0.1.0 → 10.0.1.255.

