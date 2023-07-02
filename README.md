# Reverse Proxy with Nginx and Let's Encrypt

This repository provides a reverse proxy solution using Nginx and Let's Encrypt for automatic SSL certificate generation. By leveraging Docker, Nginx, and Let's Encrypt, you can easily set up a reverse proxy server that handles SSL certification automatically.

## Prerequisites

Before using this reverse proxy solution, ensure you have the following:

- Docker installed and running on your system
- Basic familiarity with Docker and Nginx
- Domain names or subdomains that point to the server

## Getting Started

To get started with the reverse proxy, follow these steps:

1. Clone this repository to your server:

   ```shell
   git clone https://github.com/sandro-sikic/proxy.git
   ```

2. Navigate to the cloned repository:

   ```shell
   cd proxy
   ```

3. Run script to start the reverse proxy:

   ```shell
   ./start.sh
   ```

## Stopping the reverse proxy

All the containers that are using the proxy_nginx will have to be stopped before stopping the reverse proxy.

1. Navigate to the cloned repository:

   ```shell
   ./stop.sh
   ```

## Configuring containers to proxy

To add a container to the reverse proxy, you need to do the following:

- Add environment variables to the container you want to proxy
- Connect the container to the `proxy_nginx` network

example

```yml
version: '3.7'
services:
  nginx:
    image: nginx:latest
    environment:
      - VIRTUAL_HOST=yourdomain.com,www.yourdomain.com
      - VIRTUAL_PORT=80
      - LETSENCRYPT_HOST=yourdomain.com,www.yourdomain.com
      - LETSENCRYPT_TEST=true
    networks:
      - default
      - proxy_network

networks:
  proxy_nginx:
    external: true
```

## Environment variables

Required:

- `VIRTUAL_HOST`: A comma-separated list of domain names or subdomains that will be pointing to the container. For example: `mydomain.com,api.mydomain.com`.

- `LETSENCRYPT_HOST`: Similar to `VIRTUAL_HOST`, provide a comma-separated list of domain names or subdomains. This variable is used by Let's Encrypt to generate SSL certificates.

Optional:

- `VIRTUAL_PORT`: The port number that the container is listening on. Default: `80`

- `LETSENCRYPT_TEST`: Set this variable to `true` to enable Let's Encrypt staging environment. This is useful for testing your setup without hitting Let's Encrypt rate limits. Default: `false`

## Advanced configuration

For more advanced configuration options, refer to the official Nginx and Docker documentation.

- [nginx](https://github.com/nginx-proxy/nginx-proxy): Automated nginx proxy for Docker containers using docker-gen
- [acme-companion](https://github.com/nginx-proxy/acme-companion): Automated ACME SSL certificate generation for nginx-proxy
