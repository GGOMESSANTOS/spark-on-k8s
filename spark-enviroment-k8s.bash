#!/bin/bash

# Atualizar pacotes
sudo apt-get update

# Instalar dependências
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Instalar Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Instalar kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Instalar Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube /usr/local/bin/

# Iniciar Minikube com driver Docker e 6GB de RAM
minikube start --driver=docker --memory=6144

# Instalar Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Instalar Spark Operator
helm repo add spark-operator https://kubeflow.github.io/spark-operator
helm install my-release spark-operator/spark-operator --namespace spark-operator --create-namespace

# Instalar MinIO
helm repo add minio https://operator.min.io/
helm install minio minio/minio --namespace minio-system --create-namespace --set rootUser=minio,rootPassword=minio123

# Instalar Apache Airflow
helm repo add apache-airflow https://airflow.apache.org
helm install airflow apache-airflow/airflow --namespace airflow --create-namespace

# Criar arquivo env com variáveis importantes
cat << EOF > env.sh
export MINIKUBE_IP=$(minikube ip)
export MINIO_ROOT_USER=minio
export MINIO_ROOT_PASSWORD=minio123
EOF

echo "Instalação concluída. Por favor, execute 'source env.sh' para carregar as variáveis de ambiente."
