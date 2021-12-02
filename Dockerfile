FROM alpine
LABEL maintainer="root@slach.eu"

# install required packages
RUN apk add --no-cache mtools grub grub-efi parted

ADD grub /etc/default/grub

WORKDIR /gboot
ADD entrypoint.sh .

VOLUME /data
WORKDIR /data
CMD ["/gboot/entrypoint.sh"]
