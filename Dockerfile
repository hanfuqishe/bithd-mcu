# initialize from the image

FROM debian:9

# change to local source
RUN sed -i "s/http:\/\/.*.org/http:\/\/mirrors.163.com/" /etc/apt/sources.list

# install build tools and dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential git python python-ecdsa gcc-arm-none-eabi curl \
    unzip python-pip

# setup proxy for git
ENV PROXY=http://192.168.1.9:8080
RUN git config --global http.proxy  ${PROXY} && \
    git config --global https.proxy ${PROXY} && \ 
    git config --global http.sslverify false

RUN mkdir /etc/pip && echo "[global] \n proxy = ${PROXY}" > /etc/pip/pip.conf

ENV PROTOBUF_VERSION=3.4.0
RUN curl -LO "https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip"
RUN unzip "protoc-${PROTOBUF_VERSION}-linux-x86_64.zip" -d /usr
RUN pip2 install "protobuf==${PROTOBUF_VERSION}"
