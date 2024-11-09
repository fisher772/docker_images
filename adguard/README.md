# AdGuard Home. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/adguard?logo=github)](https://github.com/fisher772/adguard/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/adguard)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Nginx-Repo)](https://github.com/fisher772/nginx-le)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/adguard/pkgs/container/adguard)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/adguard)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.


[AdGuard Home reference docs](https://docs.cloudron.io/apps/adguard-home/)
[AdGuard Home official page](https://adguard.com/)

AdGuard Home is a network-wide software for blocking ads and tracking. After you set it up, it'll cover all your home devices, and you won't need any client-side software for that.

Why do I need a Sonatype Nexus?
- Ad Blocking
- Increased Privacy (DoH DNS)
- Protection from Phishing and Malicious Sites
- Analytics and Reports
- Free and Open-Source

My small fork example generates a configuration file for a reverse proxy balancing nginx which also regulates service availability at the level of service access rules. You can distribute external access to the service or restrict access. Provide access only to off-network users from VPN traffic or external IP addresses specified by you.

All you need to do to install Adguard Home:
- My installed nginx-le image
- Run the script from the git repository ./scripts/change_resolve.sh to release port 53 and restart the service, allowing for service installation
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Move configuration files from the mounted volume adguard_nginx_conf to the volume with the nginx configuration files of the nginx container:
  service* file to conf.d-le directory
  stream* file to stream.d-le directory
- Reboot Nginx container for apply configs
- Follow the instructions from the official Adguard Home source for personalized service settings


Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |
| NEXUS_CONTEXT               | '/', Contex URL path  | URL_CONTEXTPATH                          |
| LE_FQDN                     | -, Domain address     | FQDN                                     |
| CONTAINER_ALIAS             | -, Zone Name          | C_ALIAS                                  |
| SERVER_ALIAS                | -, Container address  | S_ALIAS                                  |

\* The variable "S_ALIAS" can store a list separated by a "," sign. This sign is being processed entrypoint.sh

Commands:

```bash
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/conf/service-*.conf /var/lib/docker/volumes/nginx_data/_data/conf.d-le && \
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/stream/stream-*.conf /var/lib/docker/volumes/nginx_data/_data/stream.d-le && \
docker restart nginx && \
sudo sleep 30 && docker exec -it nginx nginx -t
```
