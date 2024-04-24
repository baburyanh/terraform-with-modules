#!/bin/bash
apt-get update -y 
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/key.gpg

# Add Docker repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io

# Update package index again after adding Docker repo
apt-get update -y

# Add the current user to the docker group
usermod -a -G docker ubuntu
newgrp docker
sleep 10

# Start Docker
systemctl start docker
systemctl enable docker

# Install AWS CLI
apt-get install awscli -y

# Log in to Amazon ECR
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 905418071301.dkr.ecr.eu-north-1.amazonaws.com/brainscale

# Pull the image from ECR
docker pull 905418071301.dkr.ecr.eu-north-1.amazonaws.com/brainscale:v1

# Launch the container and expose
docker run -p 3000:3000 -d --restart=always 905418071301.dkr.ecr.eu-north-1.amazonaws.com/brainscale:v1