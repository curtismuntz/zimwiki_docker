FROM ubuntu:xenial
LABEL maintainer="me@murt.is"

RUN apt-get update && apt-get upgrade -y --no-install-recommends

RUN apt-get install -y --no-install-recommends \
        zim \
        sudo \
        locales \
        python-gtksourceview2 \
        graphviz \
        ditaa

# Set the locale (required for zim's calendar)
RUN apt-get install -y --no-install-recommends \
        language-pack-en

# cleanup after deb installs
RUN rm -rf /var/lib/apt/lists/*

# language stuff for python locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
RUN dpkg-reconfigure locales

# This assumes that you are taking notes as the 1000:1000 user id on your host machine
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/zim && \
    echo "zim:x:${uid}:${gid}:Developer,,,:/home/zim:/bin/bash" >> /etc/passwd && \
    echo "zim:x:${uid}:" >> /etc/group && \
    echo "zimALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/zim&& \
    chmod 0440 /etc/sudoers.d/zim && \
    mkdir -p /home/zim/Notebooks/Notes && \
    mkdir -p /home/zim/Pictures && \
    mkdir -p /home/zim/.config/zim && \
    chown ${uid}:${gid} -R /home/zim

# copy in zim prefs
COPY preferences.conf /home/zim/.config/zim/

# run it
USER zim
ENV HOME /home/zim
CMD /usr/bin/zim --standalone
