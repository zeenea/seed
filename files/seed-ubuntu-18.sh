#!/usr/bin/env bash

set -e
set -x

# Idempotency checking
if [ -d "/etc/ansible/facts.d" ] && [ "$(cat /etc/ansible/facts.d/seed.fact)" = "{\"planted\": true}" ]; then
    exit 42
fi

export DEBIAN_FRONTEND=noninteractive

if [ -n "$(dpkg -l | grep exim)" ]; then
    apt-get -o Dpkg::Options::="--force-confold" install postfix -y
    apt-get -o Dpkg::Options::="--force-confold" remove exim4 exim4-base exim4-config exim4-daemon-light --purge -y
fi

if [ -n "$(dpkg -l | grep python-pip)" ]; then
    apt-get -o Dpkg::Options::="--force-confold" remove python-pip --purge -y
fi

apt-get update
apt-get -o Dpkg::Options::="--force-confold" upgrade -y
apt-get update

apt-get -o Dpkg::Options::="--force-confold" install \
    sudo                \
    aptitude            \
    git                 \
    apt-transport-https \
    python3-apt         \
    python3-distutils   \
    python3-distutils-extra \
    python3-setuptools  \
    python3-dev         \
    libssl-dev          \
    libffi-dev          \
    build-essential     \
    libperl-dev         \
    -y

python3 /usr/lib/python3/dist-packages/easy_install.py pip

pip install -U pexpect pyopenssl ndg-httpsclient pyasn1 boto3
pip install -U ansible

# Leaving a custom fact for future idempotency checking
mkdir -p /etc/ansible/facts.d
echo "{\"planted\": true}" > /etc/ansible/facts.d/seed.fact
