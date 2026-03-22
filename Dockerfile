# This file makes it easier to run TeXmacs in a Docker virtualization while showing the bibref book interactively.

# How to use this file:
# 1. On Ubuntu Linux, install the package **docker.io**.
# 2. Build the image by entering `sudo docker build .`.
#    You will get an image ID at the end of the process.
# 3. Allow connection to the host's X11 server by issuing `xhost +local:docker`.
# 4. Run texmacs by entering
#    `sudo docker run -it -e DISPLAY=$DISPLAY -e LANG=$LANG -v /tmp/.X11-unix:/tmp/.X11-unix ID`.
#    where ID stands for the obtained image ID in step 2.
# 5. If you want to restart the program later, use `sudo docker start -ai CID`
#    where CID stands for the obtained container identifier. You can find it by running `sudo docker ps`.
# 6. When finished, stop the web server by using the command `sudo docker kill CID`
# 7. If no longer used, you can remove the Docker container and image by entering
#    `sudo docker rm CID` and `sudo docker rmi ID`.


# Install prerequisites:
FROM debian:trixie
RUN apt-get update && \
    apt-get -y install wget x11-apps xdg-utils firefox-esr \
        libsword-common libsword-dev libsword-utils git cmake build-essential \
        libreadline-dev libboost-dev libboost-filesystem-dev bison flex pkgconf unzip libgraphviz-dev \
        libltdl7 libqt6core6t64 libqt6gui6 libqt6network6 libqt6printsupport6 \
        libqt6svg6 libqt6widgets6 ghostscript locate fonts-stix fonts-texgyre locales \
        python3 python3-pip python3-venv

# Without this, TeXmacs will not start because of no available locales:
RUN localedef -i hu_HU -f UTF-8 hu_HU.UTF-8

# Download TeXmacs binary:
RUN wget http://www.texmacs.org/Download/ftp/tmftp/Linux/Debian_13/TeXmacs-2.1.5.amd64.deb

# Install TeXmacs:
RUN dpkg -i TeXmacs-2.1.5.amd64.deb

# Clone and build bibref (cli):
ARG GIT_COMMIT=
RUN git clone https://github.com/kovzol/bibref && \
    if [ -n "$GIT_COMMIT" ]; then cd bibref; git checkout $GIT_COMMIT; fi
WORKDIR bibref
RUN mkdir build
WORKDIR build
RUN cmake .. && make -j$(nproc) && make install || true

# Create the addbooks-cache and copy it and the installed Bibles in /tmp:
RUN bibref -a
RUN cp -a bibref-addbooks-cache /tmp
RUN cp -a ~/.sword /tmp

# Create normal user:
RUN useradd -ms /bin/bash user
RUN chown -R user:user /tmp/bibref-addbooks-cache /tmp/.sword

# Run bibref (cli) when running the container and use the addbooks-cache and the Bibles:
USER user
WORKDIR /home/user
RUN mv /tmp/bibref-addbooks-cache .
RUN mv /tmp/.sword .

# Install bibref-python:
RUN python3 -m venv .venv
RUN . .venv/bin/activate && pip install bibref-python

# Install a Hungarian Bible edition (HunRUF):
# RUN echo yes | SWORD_PATH=/home/user/.sword installmgr -ri CrossWire HunRUF # This does not work... because of missing write permissions?
RUN wget https://www.crosswire.org/ftpmirror/pub/sword/packages/rawzip/HunRUF.zip
RUN cd .sword && unzip ../HunRUF.zip # So we don't need installmgr (and the sword-utils package) at the moment.

# Create bibref session plugin for TeXmacs:
RUN mkdir -p /home/user/.TeXmacs/plugins/bibref/progs/
COPY init-bibref.scm /home/user/.TeXmacs/plugins/bibref/progs/init-bibref.scm

# Copy book and template:
COPY bibref-hu.tm /home/user/bibref-hu.tm
COPY tmbook-kovzol.ts /home/user/tmbook-kovzol.ts

# Run TeXmacs in venv to access bibref-python too (restart prevents showing welcome message):
CMD . .venv/bin/activate && texmacs -q && texmacs /home/user/bibref-hu.tm
