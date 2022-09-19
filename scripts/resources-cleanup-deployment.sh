#!/bin/bash
# 1. MongoDB cleanup
# MONGO_URI and MONGO_DB are already set as environment variables
# connect to mongoDb and drop database 
if [[ ${MONGO_DB} != *"admin"* && ${MONGO_URI} == *"<databaseName>"* ]]; then
  MONGO_URI_ENV=$(echo "${MONGO_URI/<databaseName>/"$MONGO_DB"}")
  mongo "${MONGO_URI_ENV}" --eval "db.getSiblingDB('${MONGO_DB}');db.dropDatabase()"

  # connect to mongoDb and drop the CAP database
  MONGO_URI_CAP_ENV=$(echo "${MONGO_URI/<databaseName>/"$MONGO_DB-cap"}")
  mongo "${MONGO_URI_CAP_ENV}" --eval "db.getSiblingDB('${MONGO_DB}-cap');db.dropDatabase()"
fi
# 2.Rabbitmq cleanup
# MESSAGE_QUEUE_URI and EXCHANGE_NAME are already set as environment variables
# Extract host, username and password from the MESSAGE_QUEUE_URI connection string
host=$(echo "$MESSAGE_QUEUE_URI" | cut -d "@" -f 2 | cut -d "/" -f 1)
splitted=$(echo "$MESSAGE_QUEUE_URI" | cut -d'@' -f 1)
credentials=${splitted#*//}
username=$(echo "$credentials" | cut -d ":" -f 1)
password=$(echo "$credentials" | cut -d ":" -f 2)
# Fetch all bindings and take only the destination column, which is its queue name
queuesNamesList=$(eval rabbitmqadmin --host="$host" --port=443 --ssl --username="$username" --password="$password" --vhost="$username" list bindings destination | cut -d " " -f2 | sed 1,3d | sed '$ d')
# iterate over queues names and if they contain EXCHANGE_NAME we delete that queue
for queueName in $queuesNamesList; do
  if [[ $queueName == *$EXCHANGE_NAME* ]]; then
    rabbitmqadmin --host="$host" --port=443 --ssl --username="$username" --password="$password" --vhost="$username" delete queue name="$queueName"
  fi
done
# delete rabbitmq exchange
rabbitmqadmin --host="$host" --port=443 --ssl --username="$username" --password="$password" --vhost="$username" delete exchange name="$EXCHANGE_NAME"
