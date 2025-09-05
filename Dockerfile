FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends procps tftpd-hpa && \
    mkdir -p /srv/tftp && \
    chown -R tftp:tftp /srv/tftp && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /srv/tftp
EXPOSE 69/udp
CMD ["/usr/sbin/in.tftpd", "--listen", "--foreground", "-vvv", "--user", "tftp", "--address", "0.0.0.0:69", "--secure", "/srv/tftp", "--create"]
