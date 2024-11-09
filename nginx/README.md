# Nginx-LE. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/nginx-le?logo=github)](https://github.com/fisher772/nginx-le/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/nginx-le)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/nginx-le/pkgs/container/nginx-le)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/nginx-le)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.


Nginx ("engine x") is an HTTP web server, reverse proxy, content cache, load balancer, TCP/UDP proxy server, and mail proxy server. Known for flexibility and high performance with low resource utilization

Why do I need a Nginx?
- Free and Open-Source
- Serving static and index files, autoindexing; open file descriptor cache;
- Accelerated reverse proxying with caching; load balancing and fault tolerance;
- Accelerated support with caching of FastCGI, uwsgi, SCGI, and memcached servers; load balancing and fault tolerance;
- Modular architecture. Filters include gzipping, byte ranges, chunked responses, XSLT, SSI, and image transformation filter. Multiple SSI inclusions within a single page can be processed in parallel if they are handled by proxied or FastCGI/uwsgi/SCGI servers;
- SSL and TLS SNI support;
- Support for HTTP/2 with weighted and dependency-based prioritization;
- Support for HTTP/3.
- Name-based and IP-based virtual servers;
- Keep-alive and pipelined connections support;
- Access log formats, buffered log writing, fast log rotation, and syslog logging;
- 3xx-5xx error codes redirection;
- The rewrite module: URI changing using regular expressions;
- Executing different functions depending on the client address;
- Access control based on client IP address, by password (HTTP Basic authentication) and by the result of subrequest;
- Validation of HTTP referer;
- The PUT, DELETE, MKCOL, COPY, and MOVE methods;
- FLV and MP4 streaming;
- Response rate limiting;
- Limiting the number of simultaneous connections or requests coming from one address;
- IP-based geolocation;
- A/B testing;
- Request mirroring;
- Embedded Perl;
- njs scripting language.
- ...

\* [NGINX reference docs](https://nginx.org/en/)

My image has incorporated automation in configuration, installation of appearance and ease of use. The sample monitors the configuration files of services from the input directory and reconfigures files for a secure connection. Generates free certificates through the Let's Encrypt open certification center service. The status of certificates is also monitored and new certificates are changed if they expire.

The presence image has an off-site configuration access policy based on rules:
- If the "#deny all" parameter is found in the configuration files, the script overrides its value and accepts a comment. 
- If the "allow all" parameter and the specified value for the "TR_VPN_ADDRESSES" variables are found in the configuration files, the rule is overridden using the address pool in the "TR_VPN_ADDRESSES" variables.

\* Study for general understanding and proper usage 
\*\* [NGINX Http Access Module reference doc] (https://nginx.org/en/docs/http/ngx_http_access_module.html)

All you need to do to install Nginx-LE:
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Follow the instructions from the official Adguard Home source for personalized service settings


Environment:

A more detailed explanation of the variables can be found in the git repository: nginx-le/env_example


Commands:

```bash
docker exec -it nginx nginx -t
```
