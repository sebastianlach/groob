FROM alpine
LABEL maintainer="root@slach.eu"

# install required packages
RUN apk add --no-cache mtools grub grub-efi breeze-grub parted

WORKDIR /groob
ADD grub.cfg .
ADD custom.cfg .
ADD entrypoint.sh .

VOLUME /data
WORKDIR /data
CMD ["/groob/entrypoint.sh"]
