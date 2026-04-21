#!/bin/bash

yum update -y
amazon-linux-extras install ansible2 -y
yum install git -y
git clone https://github.com /tmp/ansible

ansible-playbook /tmp/ansible/playbook.yml -c local
