# Whoami

Simple Whoami container display the current container id. Test simply your `nginx`
container by settings the `VIRTUAL_HOST`, `LETSENCRYPT_HOST`, `LETSENCRYPT_EMAIL`
environment variables defined inside the `docker-compose.yml`.

## Start the container

At the root of the folder:
```bash
dc up -d
```
