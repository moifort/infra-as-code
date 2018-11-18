#!/bin/bash

# Set
USER=$1
USER_KEY_PUB="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDORouC7FL8bmcFRPE8K78Ah7k83k0kwShBfBhrRflD12ZRp/jXRYHDIsUcaToLT0QMs6Dsg1UNKrAr4a8cabRCwDRVJkCyEJHCYyhS8dzKWIyL6u/CPjVb44pD6nyBVZp575rceT3DysPluNPpvT7eMhcMmsoogz2AhCUoMVaRcSeNs9Z2wb8M71AEHhiMzrBWswsOOvaBVi9fgpW3M6a+7FDPkHswZ9BnvVu+KVZEOT61UvGdAo/PDDTnvbGhUVXvIZcMX37vgB3ivniaL1l5pHL7O1Wn29t3E7DMc1Q2PlMcQnEadHlfP33RGACfPaMo85zMm2XWf57EgzUwssvB moi@MacBook-Air-de-Thibaut.local"
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
apt-get install -y htop unzip zip curl xz-utils tree exfat-fuse exfat-utils

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
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

#
# Install docker-compose
#
echo "Install docker-compose"
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# non-root access
echo "non root access"
groupadd docker
gpasswd -a $USER docker

#
# Add shortcup
#
echo "Install shortcut"
echo "alias dc='docker-compose'" >> /home/$USER/.bash_aliases
echo "alias dcup='dc stop && dc rm -af && dc up -d && dc logs -f --tail=300'" >> /home/$USER/.bash_aliases
echo "alias dclogs='dc logs -f --tail=300'" >> /home/$USER/.bash_aliases
echo "alias dcrm='dc stop && dc rm -af'" >> /home/$USER/.bash_aliases
