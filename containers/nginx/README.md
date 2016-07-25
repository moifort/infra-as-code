# Automatic reverse proxy and SSL with letsencrypt

This container it's the entry point of your server every request will enter here.
It's composed of two container:
* https://github.com/jwilder/nginx-proxy
* https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion

To resume it's allow you to auto configure your reverse proxy (redirect http request
`test.domain.com` to a specific container) and generate automatically your SSL certificate
with letsencrypt.

To do this, it's very simple just add in your `docker-compose.yml` environment variables
below (you can see the example in `/containers/test/docker-compose.yml`):
* `VIRTUAL_HOST`: configure your reverse proxy to the given address (e.i. test.my-domain.com)
* `LETSENCRYPT_HOST`: configure your SSL certificate to the given address (e.i. test.my-domain.com)
* `LETSENCRYPT_EMAIL`: set your mail for SSL (e.i. my@mail.com)

You can test with the `test` container defined `/containers/test/docker-compose.yml`.
1. Start `nginx` container defined in `/containers/nginx`.
2. Set `VIRTUAL_HOST`, `LETSENCRYPT_HOST`, `LETSENCRYPT_EMAIL` environment variables
in `/containers/test/docker-compose.yml` file.
3. Start `test` container defined in `/containers/test`.
4. `nginx` container will automatically see the new `test` container start with
the environment variables defined above and automatically configure reverse proxy
and SSL certificate.
5. Connect with your browser to `test.my-domain.com` url. It will display the id
of `test` container in valide `https`.

Awesome no?

## Start the container

At the root of the folder:
```bash
dc up -d
```

## Tips

* You need to have a domain name manager (I use OVH)
* To test the SSL certificate go to https://www.ssllabs.com/ssltest/
* `./conf/proxy.conf` defines default value for all vhost. Using here for `gitlab`
container. More information in the github project defined below.
* `/var/run/docker.sock:/var/run/docker.sock:ro` volume mapping defined in `docker-compose.yml`
allow the `nginx` to
