FROM busybox AS rootfs
ADD https://releases.sailfishos.org/ubu/ubuntu-trusty-20180613-android-rootfs.tar.bz2 /tmp/rootfs.tar.bz2
RUN mkdir /rootfs && tar -xjf /tmp/rootfs.tar.bz2 -C /rootfs

FROM scratch
COPY --from=rootfs /rootfs /

# Update repos
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ trusty main universe multiverse restricted' >> /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu/ trusty-security main universe multiverse restricted' >> /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu/ trusty-updates main universe multiverse restricted' >> /etc/apt/sources.list && \
    echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' >> /etc/apt/sources.list.d/git-core-ppa.list

# Import missing GPG keys
RUN curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf911ab184317630c59970973e363c90f8f1b6217" | apt-key add - && \
    curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe1dd270288b4e6030699e45fa1715d88e1df1f24" | apt-key add - && \
    curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf7c313db11f1ed148bb5117c08b3810cb7017b89" | apt-key add - && \
    rm -f *.asc

# Install additional packages for building Sailfish OS & system packages
RUN dpkg --add-architecture i386 && \
    apt-get --assume-yes update \
    && apt-get --assume-yes install \
    software-properties-common \
    && dpkg-divert --local --add /etc/init.d/systemd-logind \
    && rm -f /etc/init.d/systemd-logind \
    && ln -s /bin/true /etc/init.d/systemd-logind \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get --assume-yes update \
    && apt-get --assume-yes install \
        openjdk-8-jdk \
        imagemagick \
        libgio2.0-cil-dev \
        unicode \
        libswitch-perl \
        python-crypto \
        libncurses5-dev:i386 \
        libx11-dev:i386 \
        libreadline6-dev:i386 \
        libgl1-mesa-glx:i386 \
        zlib1g-dev:i386 \
        build-essential \
        schedtool \
        libssl-dev \
        bsdmainutils \
        vim \
        rsync \
        g++-multilib \
        gcc-multilib \
        git \
        openssh-client \
        wget

# Suppress security
RUN echo "ALL ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Defaults !pam_acct_mgmt" >> /etc/sudoers && \
    sed -i 's/jdk.tls.disabledAlgorithms=SSLv3, /jdk.tls.disabledAlgorithms=/' /etc/java-8-openjdk/security/java.security && \
    echo "* soft nofile 1000000" >> /etc/security/limits.conf && \
    echo "* hard nofile 1000000" >> /etc/security/limits.conf && \
    rm -rf /run/shm && mkdir -p /run/shm && \
    rm -rf /home/*
