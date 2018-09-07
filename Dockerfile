FROM alpine

ENV USER            user
ENV SERVER_ADDR     0.0.0.0
ENV SERVER_PORT     9090
ENV PASSWORD        R9PCbaRj
ENV METHOD          none
ENV PROTOCOL        auth_chain_b
ENV PROTOCOLPARAM   5
ENV OBFS            http_simple
ENV TRANSFER        50
ENV TIMEOUT         300
ENV DNS_ADDR        8.8.8.8
ENV DNS_ADDR_2      8.8.4.4

ARG BRANCH=manyuser
ARG WORK=/opt


RUN apk --no-cache add python \
    libsodium \
    wget


RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://github.com/bestseantt/shadowsocksr/archive/$BRANCH.tar.gz | tar -xzf - -C $WORK


WORKDIR $WORK/shadowsocksr-$BRANCH

RUN sh initcfg.sh && \
    sh setup_cymysql.sh && \
    python mujson_mgr.py -a -u $USER -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS -G $PROTOCOLPARAM -t $TRANSFER

EXPOSE $SERVER_PORT
CMD python server.py
