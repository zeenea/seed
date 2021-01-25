#!/usr/bin/env bash

set -e
set -x

# Idempotency checking
if [ -d "/etc/ansible/facts.d" ] && [ "$(cat /etc/ansible/facts.d/seed.fact)" = "{\"planted\": true}" ]; then
    exit 42
fi

yum makecache -y

yum remove pyOpenSSL -y

yum update -y

yum install \
  python-setuptools \
  python-devel \
  openssl-devel \
  sudo \
  libffi-devel \
  git \
  gcc \
  gcc-c++ \
  make \
  openssl-devel \
  libxml2 \
  libxml2-devel \
  libxslt \
  libxslt-devel \
  perl-devel \
  automake \
  -y

easy_install pip

pip install -U pexpect pyopenssl ndg-httpsclient pyasn1 boto3
pip install -U ansible

# Leaving a custom fact for future idempotency checking
mkdir -p /etc/ansible/facts.d
echo "{\"planted\": true}" > /etc/ansible/facts.d/seed.fact
