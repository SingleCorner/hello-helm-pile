FROM python:3.11-alpine

ADD requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt


RUN apk update && \
    apk add curl && \
    apk add git && \
    apk add helm

RUN curl -sSLO https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN helm repo add grafana https://grafana.github.io/helm-charts && \
    helm repo add elastic https://helm.elastic.co && \
    helm repo add bitnami https://charts.bitnami.com/bitnami && \
    helm repo add aliyun https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

RUN helm repo update

WORKDIR /app/charts

RUN helm pull grafana/grafana --version 5.8.8 && \
    helm pull elastic/elasticsearch --version 8.2.2 && \
    helm pull elastic/logstash --version 8.2.0

WORKDIR /app
ADD . /app
