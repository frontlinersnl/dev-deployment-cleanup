FROM alpine:latest

WORKDIR /source
ENV RABBITMQADMIN_VERSION="v3.9.0"
RUN apk add --no-cache ca-certificates bash git openssh curl \
    && wget -q https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/v3.8.9/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin \
    && chmod +x /usr/local/bin/rabbitmqadmin

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python \
    && python3 -m ensurepip \
    && pip3 install --no-cache --no-cache-dir --upgrade pip setuptools

# Install mongodb 
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache mongodb yaml-cpp=0.6.2-r2 \
    && apk add --no-cache mongodb-tools  # to add mongodump and mongorestore \
    && mongo --version

WORKDIR /
COPY ./scripts /opt/
RUN chmod +x /opt/resources-cleanup-deployment.sh
CMD [ "/opt/resources-cleanup-deployment.sh" ]