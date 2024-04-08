#!/bin/bash

# Install dependencies
sudo yum install -y wget tar gzip

# Step 1: Install Spark with Kubernetes support
SPARK_VERSION="3.3.2"
SPARK_DOWNLOAD_URL="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz"

wget "${SPARK_DOWNLOAD_URL}"
tar -xzf "spark-${SPARK_VERSION}-bin-hadoop3.tgz"
rm "spark-${SPARK_VERSION}-bin-hadoop3.tgz"

# Step 2: Install Kubernetes client
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Step 3: Configure kubectl to communicate with the DigitalOcean cluster
DIGITALOCEAN_CLUSTER_NAME="<your-cluster-name>"
doctl kubernetes cluster kubeconfig save "${DIGITALOCEAN_CLUSTER_NAME}"

# Step 4: Configure Spark to run on Kubernetes
K8S_MASTER_URL="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
SPARK_IMAGE="apache/spark:v${SPARK_VERSION}"

cat <<EOF > "spark-${SPARK_VERSION}-bin-hadoop3/conf/spark-defaults.conf"
spark.master=k8s://${K8S_MASTER_URL}
spark.kubernetes.container.image=${SPARK_IMAGE}
spark.kubernetes.namespace=spark
EOF

# Step 5: Create a namespace in Kubernetes for Spark
kubectl create namespace spark

echo "Apache Spark version ${SPARK_VERSION} has been installed and configured to run on the DigitalOcean Kubernetes cluster."