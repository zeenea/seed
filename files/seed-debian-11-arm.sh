#!/usr/bin/env bash

set -e
set -x

if [ -d "/etc/ansible/facts.d" ] && [ "$(cat /etc/ansible/facts.d/seed.fact)" = "{\"planted\": true}" ]; then
    exit 42
fi

export DEBIAN_FRONTEND=noninteractive

if [ -n "$(dpkg -l | grep exim)" ]; then
    apt -o Dpkg::Options::="--force-confold" install postfix -y
    apt -o Dpkg::Options::="--force-confold" remove exim4 exim4-base exim4-config exim4-daemon-light --purge -y
fi

if [ -n "$(dpkg -l | grep python-pip)" ]; then
    apt -o Dpkg::Options::="--force-confold" remove python-pip --purge -y
fi

apt update
apt -o Dpkg::Options::="--force-confold" upgrade -y

apt -o Dpkg::Options::="--force-confold" install \
    sudo                \
    aptitude            \
    git                 \
    apt-transport-https \
    python3-apt         \
    python3-distutils-extra \
    python3-setuptools  \
    python3-dev         \
    libssl-dev          \
    libffi-dev          \
    build-essential     \
    libperl-dev         \
    python3-pip         \
    -y

pip3 install -U boto3 ansible==4.9.0

# Leaving a custom fact for future idempotency checking
mkdir -p /etc/ansible/facts.d
echo "{\"planted\": true}" > /etc/ansible/facts.d/seed.fact
