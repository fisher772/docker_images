# BitBucket - Atlassian. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/bitbucket?logo=github)](https://github.com/fisher772/bitbucket/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/bitbucket)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Postgres-Repo)](https://github.com/fisher772/postgres)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Nginx-Repo)](https://github.com/fisher772/nginx-le)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/bitbucket/pkgs/container/bitbucket)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/bitbucket)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.


Bitbucket is a powerful and versatile tool for software development teams. Remote declarative source of Git code.

[BitBucket reference docs](https://confluence.atlassian.com/bitbucketserver/bitbucket-installation-guide-867338382.html)

Why do I need a BitBucket?
- Source Code Management
- Security
- Integration with Atlassian Tools: Bitbucket integrates seamlessly with other Atlassian tools like Jira and Confluence. This allows you to link code changes to project tasks and documentation, creating a cohesive workflow.
- Reporting and Analytics
- Continuous Integration and Deployment (CI/CD): Bitbucket Pipelines is a built-in CI/CD service that allows you to automate your build, test, and deployment processes. This helps ensure that your code is always in a deployable state and reduces the risk of introducing bugs.

My small fork example generates a configuration files for a reverse proxy balancing nginx which also regulates service availability at the level of service access rules. You can distribute external access to the service or restrict access. Provide access only to off-network users from VPN traffic or external IP addresses specified by you.

\* I highly recommend using the web context url path "/bitbucket"

All you need to do to install BitBucket:
- My installed nginx-le image
- My installed Postgres image
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Move configuration files from the mounted volume bitbucket_nginx_conf to the volume with the nginx configuration files of the nginx container:
  service* file to conf.d-le directory
  stream* file to stream.d-le directory
- Reboot Nginx container for apply configs
- Follow the instructions from the official Nexus source for personalized service settings


Environment:

\* A more detailed explanation of the variables can be found in the git repository: bitbucket/env_example

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |
| LE_FQDN                     | -, Domain address     | FQDN                                     |
| CONTAINER_ALIAS             | -, Zone Name          | C_ALIAS                                  |
| SERVER_ALIAS                | -, Container address  | S_ALIAS                                  |
| ATL_TOMCAT_CONTEXTPATH      | '/', Contex URL path  | URL_CONTEXTPATH                          |
| ATL_DB_TYPE                 | -, DB type            | DB_TYPE                                  |
| ATL_DB_DRIVER               | -, DB drivers         | DB_DRIVER                                |
| ATL_JDBC_URL                | -, JDBC DB address    | DB_URL                                   |
| ATL_JDBC_USER               | -, DB/Web User        | DB_USER                                  |
| ATL_JDBC_PASSWORD           | -, DB/Web Password    | DB_PASSWORD                              |


Commands:

```bash
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/conf/service-*.conf /var/lib/docker/volumes/nginx_data/_data/conf.d-le && \
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/stream/stream-*.conf /var/lib/docker/volumes/nginx_data/_data/stream.d-le && \
docker restart nginx && \
sudo sleep 30 && docker exec -it nginx nginx -t
```
