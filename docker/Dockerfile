FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
ENV IN_CONTAINER=1

# Default ARGs injected by Docker buildx
ARG TARGETARCH
COPY tools/rkdeveloptool-${TARGETARCH} /usr/bin/rkdeveloptool

#
# opencca flash server packages
#

RUN apt update -y 
RUN apt install -y build-essential autoconf automake libtool
RUN apt install -y emacs-nox nano vim sudo curl wget git \
    unzip htop tmux screen bash-completion lsof fish tmux bash \
    iproute2 net-tools dnsutils iputils-ping traceroute socat tcpdump nmap \
    build-essential cmake pkg-config gdb gdb-multiarch strace  \
    python3 python3-pip python3-venv python3-dev
RUN apt install -y usbutils udev libusb-1.0-0-dev coreutils expect
RUN apt install -y minicom screen picocom

RUN ln -s /usr/bin/python3 /usr/bin/python || true

#
# We need latest uhubctl for raspberry pi 5 support
# 
WORKDIR /root
RUN git clone https://github.com/mvp/uhubctl.git /root/uhubctl \
    && cd /root/uhubctl \
    && make -j$(nproc) \
    && sudo make install 


ENV HOME=/root
ENV PATH="/opencca/flash:$PATH"
ENV PATH="/opencca/flash/snapshot:$PATH"
ENV PATH="/opencca/flash/tools:$PATH"

RUN  git config --global --add safe.directory "*"

# For CI build
ARG BUILD_DATE=none
ARG BUILD_REF=unknown
ARG BUILD_VERSION=none

# Labels
LABEL org.opencontainers.image.title="opencca-flash"
LABEL org.opencontainers.image.description="Flash Environment for OpenCCA."
LABEL org.opencontainers.image.vendor="OpenCCA"
LABEL org.opencontainers.image.authors="Andrin Bertschi <hi@abertschi.ch>"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://opencca.github.io"
LABEL org.opencontainers.image.source="https://github.com/opencca/opencca-flash"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${BUILD_REF}"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"

CMD ["/bin/bash"]