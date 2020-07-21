docker run -d \
    -p 10080:10080 \
    -p 10080:10080/udp \
    --name ss-libev-local \
    --restart=always \
    -v /home/haoran_qi/Documents/docker/docker-shadowsocks/config:/etc/shadowsocks-libev \
    dotdash/shadowsocks-libev-vp-local-amd64