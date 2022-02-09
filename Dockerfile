FROM cirrusci/flutter:2.10.0

USER root

RUN useradd -ms /bin/bash gitpod

RUN chown -R gitpod /sdks/**

USER gitpod

ENV PUB_CACHE=/workspace/.pub_cache

RUN flutter precache
RUN flutter doctor