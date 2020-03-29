FROM java:8-jre

MAINTAINER Qingjie Zhao "zhaoqingjie@gmail.com"

WORKDIR /app

ADD ./target/qzhao-v1-log-1.0.0.jar .

COPY start-services.sh /start-services.sh

EXPOSE 8888

ENTRYPOINT ["/start-services.sh"]
