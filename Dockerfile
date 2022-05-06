FROM jupyter/minimal-notebook:lab-3.3.4

USER root

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"


RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           fuse \
           wget \
           gnupg2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O- http://neuro.debian.net/lists/focal.us-tn.full | tee /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com 0xA5D32F012649A5A9 && \
    apt-get update -qq

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           git-annex-standalone \
           graphviz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=jovyan:users requirements.txt .

COPY --chown=jovyan:users . .

USER jovyan

# RUN git submodule update --init

RUN pip install -r requirements.txt