# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/kinoite-main:42
#RUN rpm-ostree cliwrap install-to-root /    
COPY system_files /

RUN mkdir -p /var/home/build && \
	ostree container commit

RUN mkdir -p /usr/share/aurorae/themes && \
	ostree container commit

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/branding.sh && \
    ostree container commit

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    systemctl enable initial-setup && \
#   ln -s /etc/systemd/system/graphical.target.wants/initial-setup.service /usr/lib/systemd/system/initial-setup.service && \
#   ln -s /etc/systemd/system/multi-user.target.wants/initial-setup.service /usr/lib/systemd/system/initial-setup.service && \
    ostree container commit

RUN rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /tmp /var/tmp && \
    chmod 1777 /tmp /var/tmp && \
    ostree container commit

#   RUN mkdir -p /etc/skel/ && \
#   #	cp /etc/skel/* -Rv /var/home/*/ && \
#   	cp /etc/skel/.* -Rv /var/home/*/ && \
#   	ostree container commit

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

