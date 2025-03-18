FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive
ENV IN_CONTAINER=1

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

CMD ["/bin/bash"]