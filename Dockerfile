# FROM debian:bullseye-20211201

# COPY . /workdir
# WORKDIR /workdir
# RUN ./install.sh docker
# ENTRYPOINT ["./start_openplc.sh"]

#FROM debian:bullseye-20211201 as builder
FROM sheng2216/open_plc:0.1 as builder
#COPY . /workdir
#WORKDIR /workdir
#RUN ./install.sh docker



# Runnner image
FROM alpine:3.15 as runner


# Copy fles from builder and repo 
COPY --from=builder /workdir /workdir

WORKDIR /workdir

RUN apk add --no-cache g++ libcap python3 py3-flask \
        py3-flask-login py3-pip py3-pyserial sqlite && \
    rm -f /var/cache/apk/* && \
    pip3 install pymodbus && \
    setcap 'cap_net_bind_service=+ep' /usr/bin/python3.9 && \
    rm -rf /tmp/*

USER root

EXPOSE 502 8080 20000 44818

# Launch our binary on container startup.
ENTRYPOINT ["./start_openplc.sh"]

