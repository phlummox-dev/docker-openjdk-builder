
FROM ubuntu:jammy

# software-properties-common => for add-apt-repository
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      autoconf                        \
      build-essential                 \
      ccache                          \
      curl                            \
      file                            \
      g++                             \
      gcc                             \
      git                             \
      graphviz                        \
      libasound2-dev                  \
      libcups2-dev                    \
      libffi-dev                      \
      libfontconfig1-dev              \
      libx11-dev                      \
      libxext-dev                     \
      libxrandr-dev                   \
      libxrender-dev                  \
      libxt-dev                       \
      libxtst-dev                     \
      locales                         \
      make                            \
      openjdk-21-jdk-headless         \
      pandoc                          \
      pigz                            \
      pkg-config                      \
      software-properties-common      \
      sudo                            \
      systemtap-sdt-dev               \
      unzip                           \
      wget                            \
      zip && \
  apt-get --purge remove -y .\*-doc$ && \
  apt-get autoclean && \
  apt-get clean -y && \
  apt-get --purge -y autoremove && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
   && locale-gen en_US.utf8 \
   && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ARG USER_NAME=user
ARG USER_ID=1001
ARG USER_GID=1001

RUN : "adding user" && \
  set -x; \
  addgroup --gid ${USER_GID} ${USER_NAME} && \
  adduser --home /home/${USER_NAME} --disabled-password --shell /bin/bash --gid ${USER_GID} --uid ${USER_ID} --gecos '' ${USER_NAME} && \
  echo "%${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER_NAME}

RUN mkdir -p ~/.local/bin

USER ${USER_NAME}
ENV HOME=/home/${USER_NAME}
ENV PATH="$HOME/.local/bin:${PATH}"
WORKDIR $HOME

#COPY phlummox.tar /home/phlummox/phlummox.tar

RUN :  \
  git config --global user.name user && \
  git config --global user.email "user@users.noreply.github.com"

ARG JDK_VERSION="jdk-21+13"

RUN \
  sudo mkdir /opt/work && \
  sudo chown ${USER_NAME} /opt/work && \
  cd /opt/work && \
  wget https://github.com/openjdk/jdk/archive/refs/tags/${JDK_VERSION}.tar.gz && \
  tar xf *.tar.gz && \
  rm *.tar.gz

# cd jdk
# sh ./configure --with-boot-jdk=$HOME/jdk-16/
# make images
