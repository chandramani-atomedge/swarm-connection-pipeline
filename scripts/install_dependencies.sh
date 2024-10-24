sudo apt-get update -y

docker service rm aura-frontend || true
docker service rm aura-app || true
docker service rm aura-db || true

docker service create \
  --name aura-frontend \
  --network aura-network \
  --constraint 'node.labels.mylabel == worker1' \
  --publish published=80,target=80 \
  --replicas 1 \
  270514764245.dkr.ecr.us-east-1.amazonaws.com/aura-frontend:latest

docker service create \
  --name aura-app \
  --hostname localhost \
  --constraint 'node.labels.mylabel == worker1' \
  --network aura-network \
  --publish published=8080,target=8080 \
  --replicas 1 \
  270514764245.dkr.ecr.us-east-1.amazonaws.com/aura-app:latest

docker service create \
  --name aura-db \
  --network aura-network \
  --constraint 'node.labels.mylabel == worker2' \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=password \
  --env POSTGRES_DB=hrms \
  --publish published=5432,target=5432 \
  --replicas 1 \
  270514764245.dkr.ecr.us-east-1.amazonaws.com/aura-postgres:latest
