# Infrastructure
This project allow you to set a secure development environment and infrastructure
for a team very quickly with **Docker**.

## What is about?
Out of the box securised server with fully functionnal tools:
* **Docker engine** and **docker-compose**
* Automatic **reverse proxy** and **SSL certificate** with letsencrypt.
* **Gitlab** awesome open source collaborative git tools and continuous
integration/deployment.

## Requirement
* A server with Debian **Jessy** version. It's important to have **Jessy** or
upper version because docker cannot work. **Kimsufi** server (cheap and dedicated):
http://www.kimsufi.com/fr/serveurs.xml.
* A domain name manager. **OVH**: https://www.ovh.com/fr/domaines/
* No need to SSL certificate with letsencrypt it's free and nothing to configure!

## Server installation
One thing that can take time on a fresh new install is to secures it, install tools
etc. But don't worry I make a simple script `install.sh` that do everything for you.
For a short explanation of the script see [install.sh](#installsh) section.

1. On your computer create a ssh key `ssh-keygen -t rsa -C "your@mail.com"`
4. Run the `install.sh "userName" "myPublicKey" "sshPort"`

## install.sh
The script will secures your server, creating a specific user and installing docker
and other tools.

## Containers
* `nginx`: Entrypoint of all your http requests. Automatic reverse proxy and SSL
certificate. More informations in [containers/nginx/README.md](README.md).
* `test`: Simple Whoami that display the conainer id in the browser. Used to simply
test the automatic reverse proxy and SSL certificate. More informations in
[containers/test/README.md](README.md).

