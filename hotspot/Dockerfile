FROM debian:bookworm

RUN apt update && apt install -y network-manager iproute2 iw && \
    apt clean && rm -rf /var/lib/apt/lists/*

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

CMD ["/hotspot/hotspot.sh"]