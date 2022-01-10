#!/usr/bin/env bash

set -e
set -x

# Idempotency checking
if [ -d "/etc/ansible/facts.d" ] && [ "$(cat /etc/ansible/facts.d/seed.fact)" = "{\"planted\": true}" ]; then
    exit 42
fi

sudo yum install git -y

pip3 install -U boto
pip3 install -U boto3
pip3 install -U ansible==4.9.0

# Leaving a custom fact for future idempotency checking
mkdir -p /etc/ansible/facts.d
echo "{\"planted\": true}" > /etc/ansible/facts.d/seed.fact
