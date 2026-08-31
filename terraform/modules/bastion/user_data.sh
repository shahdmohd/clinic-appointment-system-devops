#!/bin/bash
set -eux

yum update -y

yum install -y \
  git \
  python3 \
  python3-pip \
  awscli

# Install Ansible and AWS Python libraries for ec2-user
sudo -u ec2-user python3 -m pip install --user --upgrade pip
sudo -u ec2-user python3 -m pip install --user ansible boto3 botocore

# Add local pip bin path for ec2-user
echo 'export PATH=$PATH:/home/ec2-user/.local/bin' >> /home/ec2-user/.bashrc

# Install amazon.aws Ansible collection for ec2-user
sudo -u ec2-user /home/ec2-user/.local/bin/ansible-galaxy collection install amazon.aws

# Create useful directories
mkdir -p /home/ec2-user/projects
mkdir -p /home/ec2-user/.ssh

chown -R ec2-user:ec2-user /home/ec2-user/projects /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

# Optional: set hostname
hostnamectl set-hostname bastion-ansible