#!/bin/bash
set -ex  # Modo Debug 

exec > >(tee /var/log/user_data.log | logger -t user-data ) 2>&1

echo "Actualizando paquetes..."
sudo yum update -y

echo "Instalando Git..."
sudo yum install -y git
git --version

echo "Clonando repositorio..."
sudo -u ec2-user git clone https://github.com/sergioortiz17/devops-interview-solutions.git /home/ec2-user/devops-interview-solutions
ls -lah /home/ec2-user/devops-interview-solutions

echo "Instalando Docker..."
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

echo "Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Obteniendo IP pública de la instancia..."
INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo "Creando archivo .env en el frontend con la IP de la instancia..."
cat <<EOF > /home/ec2-user/devops-interview-solutions/2prueba_solution/frontend/.env
REACT_APP_API_URL=http://$INSTANCE_IP:8000/api/
REACT_APP_API_SERVER=http://$INSTANCE_IP:8000/api/
EOF

echo "Cambiando permisos del archivo .env..."
sudo chown ec2-user:ec2-user /home/ec2-user/devops-interview-solutions/2prueba_solution/frontend/.env

echo "Creando archivo .env en el backend con la IP de la instancia..."
cat <<EOF > /home/ec2-user/devops-interview-solutions/2prueba_solution/backend/.env
FRONTEND_URL="http://$INSTANCE_IP:3000"
FRONTEND_IP="$INSTANCE_IP"
EOF

echo "Cambiando permisos del archivo .env..."
sudo chown ec2-user:ec2-user /home/ec2-user/devops-interview-solutions/2prueba_solution/backend/.env

echo "Exportar automáticamente todas las variables del .env en cada inicio de sesión"
echo "Cargando variables del .env globalmente..."
echo "set -o allexport; source /home/ec2-user/devops-interview-solutions/2prueba_solution/backend/.env; set +o allexport" | sudo tee -a /etc/profile.d/custom_env.sh

echo "Dar permisos de ejecución"
sudo chmod +x /etc/profile.d/custom_env.sh

echo "Aplicar las variables inmediatamente sin reiniciar la sesión"
set -o allexport
source /home/ec2-user/devops-interview-solutions/2prueba_solution/backend/.env
set +o allexport

echo "Finalizado el script de configuración de user_data"
