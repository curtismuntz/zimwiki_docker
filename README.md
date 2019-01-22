Dockerfile for running zimwiki software. Assumes you have the userid 1000:1000

Run via something similar to:
```
custom_zim() {
    KEY=$(xauth list  |grep $(hostname) | awk '{ print $3 }' | head -n 1)
    DCK_HOST=docker-zim
    xauth add $DCK_HOST/unix:0 . $KEY
    docker run --rm -it -d \
       --user=$(id -u $(whoami)) \
       -e DISPLAY=unix$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v $HOME/.Xauthority:/tmp/.Xauthority \
       -v $HOME/Documents/Notebooks/Notes:/home/zim/Notebooks/Notes \
       --name zim \
       -h $DCK_HOST \
       -e XAUTHORITY=/tmp/.Xauthority  \
       murtis/zimwiki
}
```
