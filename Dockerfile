#humschi/cidrtools:alpine-3.19.1
FROM alpine:3.19.1

ENV PUID="2001" \
    PGID="2001" \
    TZ=Europe/Rome \
    workdir=/usr/src/app \
    PATH=/${workdir}/bin:$PATH \
    startScript=start.sh

WORKDIR ${workdir}

COPY . .

RUN apk -U --no-cache --no-progress upgrade; \
    apk add --update-cache --upgrade --no-cache --no-progress bash git nano python3 py3-pip py3-wheel tzdata; \
    cp /usr/share/zoneinfo/$TZ /etc/localtime; \
    ln -s /usr/bin/python3 /usr/bin/python; \
    python3 -m venv ${workdir}; \
    . ${workdir}/bin/activate; \
    pip3 install --upgrade pip ;\
    pip3 install requests; \
    pip3 install --no-cache-dir -r requirements.txt; \
    chown -R ${PUID}:${PGID} ${workdir}; \
    # Check for start.sh and make it executable
    if [ -f ${startScript} ]; then chmod a+x ${startScript}; fi

USER ${PUID}:${PGID}

EXPOSE 5000
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["${workdir}/${startScript}"]