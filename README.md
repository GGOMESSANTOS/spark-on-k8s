# Spark Cluster Setup with MinIO and Airflow

Este projeto fornece um script Bash que configura um ambiente completo para trabalhar com Apache Spark, MinIO e Apache Airflow em um cluster Kubernetes local usando Minikube. O script instala e configura todas as dependências necessárias, incluindo kubectl, minikube, docker, helm, spark-operator, MinIO e Apache Airflow.

## Pré-requisitos

- Sistema operacional Linux
- 12 GB de RAM disponível
- Conexão com a internet

## Instalação

1. Clone este repositório em sua máquina local:

   ```
   git clone https://github.com/GGOMESSANTOS/spark-on-k8s
   cd spark-on-k8s
   ```

2. Torne o script `setup.sh` executável:

   ```
   chmod +x setup.sh
   ```

3. Execute o script como root:

   ```
   sudo ./setup.sh
   ```

   O script irá instalar todas as dependências necessárias e configurar o ambiente.

4. Após a conclusão do script, carregue as variáveis de ambiente:

   ```
   source env.sh
   ```

## Uso

- **MinIO**: Após a instalação, o MinIO estará disponível em `http://<MINIKUBE_IP>:9000` com as credenciais `minio` para usuário e `minio123` para senha.

- **Apache Airflow**: O Apache Airflow será instalado no namespace `airflow`. Você pode acessar a interface web do Airflow executando:

  ```
  kubectl port-forward svc/airflow-webserver --namespace airflow 8080:8080
  ```

  Então, acesse `http://localhost:8080` em seu navegador.

- **Spark Cluster**: Um exemplo de configuração de cluster Spark é fornecido no arquivo `spark-cluster.yaml`. Você pode aplicar essa configuração usando:

  ```
  kubectl apply -f spark-cluster.yaml
  ```

  Isso criará um cluster Spark com um driver e dois executores.

## Limpeza

Para remover todos os recursos criados pelo script, execute:

```
minikube delete
```

## Contribuição

Contribuições são bem-vindas! Abra um issue ou envie um pull request para reportar problemas ou sugerir melhorias.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
```

Sinta-se à vontade para ajustar o conteúdo deste README.md de acordo com suas necessidades específicas. Certifique-se de atualizar as seções relevantes, como pré-requisitos, instruções de instalação e uso, dependendo das alterações que você fez no script `setup.sh`.
