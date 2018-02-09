FROM mikafouenski/debian-mono
MAINTAINER mikafouenski

ENV XDG_CONFIG_HOME="/config/xdg"

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt install -y --no-install-recommends git nodejs && \
    git clone https://github.com/lidarr/Lidarr.git && \
    cd Lidarr && \
    npm install && \
    git submodule update --init && \
    export MONO_IOMAP="case" && \
    mono ./tools/nuget/nuget.exe restore ./src/Lidarr.sln && \
    xbuild ./src/Lidarr.sln /t:Configuration=Release /t:Build && \
    node ./node_modules/gulp/bin/gulp.js build && \
    cp -a _output /opt/Lidarr && \
    apt remove -y git nodejs && \
    apt autoremove -y && \
    rm -rf /Lidarr /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /

EXPOSE 8686
VOLUME /config /downloads /music

