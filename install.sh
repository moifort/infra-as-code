#!/bin/bash

# Set
USER=$1
USER_KEY_PUB=$2
SSH_PORT=$3


if [ -z "$USER" ]; then
    echo "User name is not set"
    exit 1;
fi
if [ -z "$USER_KEY_PUB" ]; then
    echo "User ssh public key is not set"
    exit 1;
fi
if [ -z "$SSH_PORT" ]; then
    echo "SSH port is not set"
    exit 1;
fi

#
# Install utilities
#
echo "Install utilities (htop, zip, curl, etc.)"
apt-get install -y htop unzip zip curl xz-utils tree

#
# Create user with ssh key
#
echo "Create user $USER with specific key"

# Create user
useradd $USER -s /bin/bash -m

# Setup user ssh
mkdir /home/$USER/.ssh
echo $USER_KEY_PUB >> /home/$USER/.ssh/authorized_keys
chmod 600 /home/$USER/.ssh/authorized_keys
chmod 700 /home/$USER/.ssh
chown -R $USER:$USER /home/$USER/.ssh

#
# Setup ssh
#

# Setup
echo "Setup ssh with user: $USER and port: $SSH_PORT"

# Setting openssh
echo "Set /etc/ssh/sshd_config file"
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
echo "LoginGraceTime 20s" >> /etc/ssh/sshd_config
echo "MaxAuthTries 1" >> /etc/ssh/sshd_config
sed -i "s/RSAAuthentication yes/RSAAuthentication no/" /etc/ssh/sshd_config
echo "UsePAM no" >> /etc/ssh/sshd_config
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
echo "AllowGroups sshusers" >> /etc/ssh/sshd_config
echo "MaxStartups 2" >> /etc/ssh/sshd_config

echo "Add $USER in sshusers group"
groupadd sshusers
usermod -a -G sshusers $USER

echo "Restart SSH service"
service ssh restart

#
# Install docker v1.11
#
echo "Install docker"

# Init
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

# non-root access
echo "non root access"
groupadd docker
gpasswd -a $USER docker

echo "alias dc='docker-compose'" >> /home/$USER/.bashrc
