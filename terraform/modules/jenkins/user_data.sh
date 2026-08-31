#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/jenkins-user-data.log | logger -t jenkins-user-data -s 2>/dev/console) 2>&1

dnf update -y

dnf install -y \
  git \
  wget \
  unzip \
  tar \
  docker \
  awscli \
  python3 \
  python3-pip \
  fontconfig \
  java-21-amazon-corretto \
  dnf-plugins-core \
  yum-utils

# Install Terraform
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
dnf install -y terraform

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

dnf install -y jenkins

systemctl enable docker
systemctl start docker

systemctl enable jenkins
systemctl start jenkins

usermod -aG docker ec2-user
usermod -aG docker jenkins

python3 -m pip install --upgrade pip || true
python3 -m pip install ansible boto3 botocore || true

terraform version || true
aws --version || true
ansible --version || true

systemctl restart jenkins

cat > /etc/motd <<'EOF'
Jenkins is installed.

Open Jenkins:
http://<jenkins-public-ip>:8080

Get initial admin password:
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Check user data logs:
sudo cat /var/log/jenkins-user-data.log

Check Terraform:
terraform version
EOF