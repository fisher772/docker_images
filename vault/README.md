# Vault HCL. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/vault?logo=github)](https://github.com/fisher772/vault/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/vault)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Nginx-Repo)](https://github.com/fisher772/nginx-le)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/vault/pkgs/container/vault)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/vault)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.


[Vault HCL reference docs](https://developer.hashicorp.com/vault/docs)

Why do I need a Vault?
- Secure Storage
- Access Control
- Dynamic Secrets
- Data Encryption
- Audit and Monitoring
- Integration: Vault integrates easily with various systems and tools, such as Kubernetes, CI/CD pipelines, and cloud providers, making it easier to manage secrets in complex infrastructures.


My small fork example generates a configuration files for a reverse proxy balancing nginx which also regulates service availability at the level of service access rules. You can distribute external access to the service or restrict access. Provide access only to off-network users from VPN traffic or external IP addresses specified by you.

All you need to do to install Vault:
- My installed nginx-le image
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Move configuration files from the mounted volume vault_nginx_conf to the volume with the nginx configuration files of the nginx container:
  service* file to conf.d-le directory
  stream* file to stream.d-le directory
- Reboot Nginx container for apply configs
- Follow the instructions from the official Nexus source for personalized service settings


Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |
| VAULT_DEV_ROOT_TOKEN_ID     | Auto, Web Token       | TOKEN                                    |
| LE_FQDN                     | -, Domain address     | FQDN                                     |
| CONTAINER_ALIAS             | -, Zone Name          | C_ALIAS                                  |
| SERVER_ALIAS                | -, Container address  | S_ALIAS                                  |


Commands:

```bash
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/conf/service-*.conf /var/lib/docker/volumes/nginx_data/_data/conf.d-le && \
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/stream/stream-*.conf /var/lib/docker/volumes/nginx_data/_data/stream.d-le && \
docker restart nginx && \
sudo sleep 30 && docker exec -it nginx nginx -t
```
