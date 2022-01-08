FROM alpine
LABEL maintainer="root@slach.eu"

# install required packages
RUN apk add --no-cache mtools grub grub-efi parted dosfstools

WORKDIR /groob
ADD grub.cfg .
ADD custom.cfg .
ADD themes themes
ADD entrypoint.sh .

VOLUME /data
WORKDIR /data

VOLUME /boot

CMD ["/groob/entrypoint.sh"]
