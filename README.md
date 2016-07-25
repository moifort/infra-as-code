# Infrastructure

This project allow you to set a development environment and infrastructure for a team very quickly. Just follow this tutorial.

## Server installation

1. By a server, I can advice you  Kimsufi server: cheap and dedicated: http://www.kimsufi.com/fr/serveurs.xml
2. Install a Debian **Jessy** version, not lower than Jessy version, because can not use Docker engine on lower version :(
3. On your computer create a ssh key:
```bash
ssh-keygen -t rsa -C "your@mail.com"
```
4. Run the `install.sh`


## Containers

* `nginx`: Entrypoint of all your http request. Automatic reverse proxy and SSL
certificate. More informations in [./containers/nginx/README.md](README.md).
* `test`: Simple Whoami that display the conainer id in the browser. Used to simply
test the automatic reverse proxy and SSL certificate. More informations in
[./containers/test/README.md](README.md).
