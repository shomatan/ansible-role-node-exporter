FROM centos:7

RUN set -xe \
    && yum install -y epel-release \
    && yum install -y python-pip \
    && pip install pip --upgrade \
    && pip install ansible

WORKDIR /test

RUN printf '[defaults]\nroles_path=./' > ansible.cfg