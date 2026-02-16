#!/bin/bash
set -e

# Update and install dependencies
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release



# Install Docker
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Setup project directory
mkdir -p /home/ubuntu/strapi
cd /home/ubuntu/strapi

# Write docker-compose.yml
cat <<EOF > docker-compose.yml
${docker_compose_content}
EOF

# Write nginx.conf
cat <<EOF > nginx.conf
${nginx_conf_content}
EOF

# Authenticate Docker to ECR
# Authenticate Docker to Docker Hub
echo "${docker_password}" | docker login --username "${docker_username}" --password-stdin

# Start services
docker compose up -d
