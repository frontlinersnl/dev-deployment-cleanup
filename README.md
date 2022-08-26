[![logo](./logo.jpg)](https://inforit.nl)

# dev-deployment-cleanup docker image

This container image can be used to automatically drop mongoDB databases en clean-up rabbitmq resources like an exchange, its bindings and destion queues.

## Usage

## container variables

| Variable                 | Purpose                                                                                          |
| ------------------------ | -------------------------------------------------------------------------------------------------|
| MONGO_URI                | URI which is used in order to connect to a Mongo database instance                               |
| MONGO_DB                 | Databasename inside MongoDB which will be dropped                                                |
| MESSAGE_QUEUE_URI        | URI which is used in order to connect to a RabbitMQ instance                                     |
| EXCHANGE_NAME            | Name of RabbitMQ exchange that will be deleted together with its bindings and their destinations |

## update instructions

1. update dockerfile
2. build local version:

   ```sh
   docker build -t inforitnl/dev-deployment-cleanup .
   ```

3. push new version to dockerhub:

   ```sh
   docker push inforitnl/dev-deployment-cleanup
   ```

4. tag and push again (optional but recommended):

   ```sh
   docker tag inforitnl/dev-deployment-cleanup inforitnl/dev-deployment-cleanup:1.0.0
   docker push inforitnl/dev-deployment-cleanup:1.0.0
   ```
