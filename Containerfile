FROM ubuntu:26.04 AS source

ADD --checksum=sha256:79c8590a1744c220d72cbed0ea91c6e2a7f4594292699b2fb3364ebd713cd566 https://github.com/arduino/arduino-ide/releases/download/2.3.10/arduino-ide_2.3.10_Linux_64bit.AppImage /tmp/source

RUN chmod 0755 /tmp/source && \
    cd /tmp && \
    ./source --appimage-extract >/dev/null && \
    mv /tmp/squashfs-root /out

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /out /opt/arduino-ide
COPY icon.png /usr/share/icons/hicolor/128x128/apps/arduino-ide.png

RUN apt-get update && \
    apt-get install -y libasound2t64 libnss3 libxss1 && \
    mkdir -p /usr/share/applications && \
    printf '#!/bin/sh\nexec /opt/arduino-ide/AppRun "$@"\n' > /usr/bin/arduino-ide && \
    chmod 0755 /usr/bin/arduino-ide && \
    printf '[Desktop Entry]\nName=Arduino IDE\nExec=arduino-ide %F\nIcon=arduino-ide\nType=Application\nCategories=Development;IDE;\n' > /usr/share/applications/cc.arduino.IDE2.desktop && \
    cpak-clean-junk
