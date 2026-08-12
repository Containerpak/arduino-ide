FROM ghcr.io/containerpak/gtk:main

ADD --checksum=sha256:79c8590a1744c220d72cbed0ea91c6e2a7f4594292699b2fb3364ebd713cd566 https://github.com/arduino/arduino-ide/releases/download/2.3.10/arduino-ide_2.3.10_Linux_64bit.AppImage /tmp/source
COPY icon.png /usr/share/icons/hicolor/128x128/apps/arduino-ide.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends fuse3 libgtk-3-0 && \
    mkdir -p /opt/arduino-ide && install -m 0755 /tmp/source /opt/arduino-ide/arduino-ide.AppImage && printf '#!/bin/sh\nexec /opt/arduino-ide/arduino-ide.AppImage --appimage-extract-and-run "$@"\n' > /usr/bin/arduino-ide && chmod 0755 /usr/bin/arduino-ide && printf '[Desktop Entry]\nName=Arduino IDE\nExec=arduino-ide %F\nIcon=arduino-ide\nType=Application\nCategories=Development;IDE;\n' > /usr/share/applications/cc.arduino.IDE2.desktop && \
    cpak-clean-junk
