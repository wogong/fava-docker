FROM python:3.5.1-alpine

ENV BEANCOUNT_INPUT_FILE ""
ENV FAVA_OPTIONS "-H 0.0.0.0"
ENV FINGERPRINT "46:de:34:e7:9b:18:cd:7f:ae:fd:8b:e3:bc:f4:1a:5e:38:d7:ac:24"
ENV BUILDDEPS "libxml2-dev libxslt-dev gcc musl-dev mercurial git nodejs make g++"
ENV RUNDEPS "libxml2 libxslt"

RUN cd /root \
        && apk add --update $BUILDDEPS $RUNDEPS \
        && hg clone --config hostfingerprints.bitbucket.org=$FINGERPRINT https://bitbucket.org/blais/beancount \
        && python3 -mpip install ./beancount \
        && git clone https://github.com/aumayr/fava.git \
        && make -C fava build-js \
        && rm -rf fava/fava/static/node_modules \
        && python3 -mpip install ./fava \
        && python3 -mpip uninstall --yes pip \
        && rm -rf /root \
        && apk del $BUILDDEPS \
        && rm -rf /var/cache/apk/*

# Default fava port number
EXPOSE 5000

CMD fava $FAVA_OPTIONS $BEANCOUNT_INPUT_FILE