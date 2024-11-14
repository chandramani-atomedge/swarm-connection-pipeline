#!/bin/bash

# Remove existing stack
docker stack rm aura-stack || true

# Get Docker login credentials and log in
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 270514764245.dkr.ecr.us-east-1.amazonaws.com

# Retrieve the Docker tags from SSM Parameter Store
AURA_DB_TAG=$(aws ssm get-parameter --name "database-image-tag" --region ap-south-1 --query "Parameter.Value" --output text)
AURA_APP_TAG=$(aws ssm get-parameter --name "backend-image-tag" --region ap-south-1 --query "Parameter.Value" --output text)
AURA_FRONTEND_TAG=$(aws ssm get-parameter --name "frontend-image-tag" --region ap-south-1 --query "Parameter.Value" --output text)

# Export the variables so they are available to docker-compose
export AURA_DB_TAG
export AURA_APP_TAG
export AURA_FRONTEND_TAG

docker stack deploy -c /home/ubuntu/swarm_connection/docker-compose.yml --detach aura-stack
