# Ansible role: seed

This role is meant to make a new server meet [Managed Node Requirements](http://docs.ansible.com/ansible/intro_installation.html#managed-node-requirements), so you can manage it using Ansible properly. It also installs Ansible itself on the target servers.

An example of using this role could be:

* Add this to a `requirements.yml` file:
```
- name: seed
  src: git+https://gitlab.com/wescalefr-oss/ansible-roles/seed.git
  version: master
```

* Install via `ansible-galaxy`:
```
ansible-galaxy install -r requirements.yml
```

* Use it *without gathering facts*, just in case Python is absent or in the wrong version:
```
---
- hosts: target_servers
  become: true
  gather_facts: no

  roles:
    - seed
```
