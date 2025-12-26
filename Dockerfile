FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    python3-pygame \
    xvfb \
    x11vnc \
    fluxbox \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/novnc && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/heads/master.zip | unzip -d /opt/novnc -

WORKDIR /app
COPY . /app

EXPOSE 6080

CMD sh -c "\
Xvfb :1 -screen 0 1024x768x16 & \
fluxbox & \
x11vnc -display :1 -nopw -forever & \
/opt/novnc/noVNC-master/utils/novnc_proxy --vnc localhost:5900 --listen 6080 & \
DISPLAY=:1 python app.py \
"