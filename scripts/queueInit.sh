#!/bin/bash

echo "Iniciando configuração dos tópicos Kafka..."

# Aguarda o Kafka estar disponível
echo "Aguardando Kafka estar disponível..."
while ! /opt/kafka/bin/kafka-topics.sh --bootstrap-server queue:29092 --list &>/dev/null; do
  echo "Kafka ainda não está disponível, aguardando..."
  sleep 5
done

echo "Kafka está disponível!"


TOPICS=("ingest-logs:3:1")

echo "Criando tópicos..."
# Cria cada tópico
for topic_config in "${TOPICS[@]}"; do
  IFS=':' read -r topic_name partitions replication <<< "$topic_config"
  echo "Criando tópico: $topic_name com $partitions partições e fator de replicação $replication"
  /opt/kafka/bin/kafka-topics.sh --bootstrap-server queue:29092 \
    --create \
    --topic "$topic_name" \
    --partitions "$partitions" \
    --replication-factor "$replication" \
    --if-not-exists
done

echo "Listando tópicos criados:"
/opt/kafka/bin/kafka-topics.sh --bootstrap-server queue:29092 --list
echo "Configuração dos tópicos concluída!"