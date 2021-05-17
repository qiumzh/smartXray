FROM alpine

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip \
	&& mkdir /tmp/xray \
	&& curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
	&& curl -L -H "Cache-Control: no-cache" -o /etc/config.json https://raw.githubusercontent.com/qiumzh/smartXray/okteto/config.json
	&& unzip /tmp/xray/xray.zip -d /tmp/xray \
	&& install -m 755 /tmp/xray/xray /usr/local/bin/xray \
	&& rm -rf /tmp/xray \
	&& apk del .build-deps

CMD ["/usr/local/bin/xray", "-config", "/etc/config.json"]
EXPOSE 8080