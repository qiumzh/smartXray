FROM alpine

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh
RUN apk del .build-deps