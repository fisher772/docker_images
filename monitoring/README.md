# Elastic Stack: Elasticsearch, Logstash, Kibana, Filebeat

[![GitHub](https://img.shields.io/github/v/release/fisher772/kibana?logo=github)](https://github.com/fisher772/kibana/releases)
[![GitHub](https://img.shields.io/github/v/release/fisher772/nginx-le?logo=github)](https://github.com/fisher772/nginx-le/releases)
[![GitHub](https://img.shields.io/github/v/release/fisher772/redis?logo=github)](https://github.com/fisher772/redis/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Kibana-Repo)](https://github.com/fisher772/kibana)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Nginx-Repo)](https://github.com/fisher772/nginx-le)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Redis-Repo)](https://github.com/fisher772/redis)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/kibana/pkgs/container/kibana)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/nginx-le/pkgs/container/nginx-le)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/redis/pkgs/container/redis)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/kibana)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/nginx-le)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/redis)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.

A simple "Monitoring/Observability" example for tracking issues in a "home infrastructure/ecosystem" using Grafana + Prometheus + Node-Exporter + cAdvisor in docker containers.
The main goal is to simplify the deployment of centralized monitoring in a containerized environment and minimize manual configuration.

\* In this case, I do not use email notification and do not use Prometheus alert manager. All notifications and triggers come from Grafana. I am comfortable using Telegram. I do not think that email distribution outside the enterprise or even in a beauty salon is relevant at the moment.

[Grafana official page](https://grafana.com/grafana)
[Grafana reference docs](https://grafana.com/docs/grafana/latest)

[Prometheus official page](https://prometheus.io)
[Prometheus reference docs](https://prometheus.io/docs/prometheus/latest)

Prometheus is an open-source systems monitoring and alerting. Prometheus collects and stores its metrics as time series data, i.e. metrics information is stored with the timestamp at which it was recorded, alongside optional key-value pairs called labels.

I recommend using metrics collectors such as:
- Node-Exporter - for system analysis Linux Node
- cAdvisor - for Docker and Kubernetes

A simple "Monitoring/Observability" example for tracking issues in a "home infrastructure/ecosystem" using ELK stack + Redis in docker containers.
The main goal is to simplify the deployment of centralized monitoring in a containerized environment and minimize manual configuration.

Grafana is an open-source analytics and interactive visualization web application used for monitoring application performance. It allows users to ingest data from a wide range of sources, query and display it in customizable charts, set alerts for abnormal behavior, and visualize data on dashboards.

Since Grafana is an ambassador in metrics visualization. You can thus immerse yourself in a long and exciting process of creating your dashboards, but whether it is necessary is up to you.

There are official and custom ready-made dashboards for different solutions. I suggest not to reinvent the wheel for standard solutions and use cat solutions for visualization. Service visualization, docker visualization, kubernetes visualization, etc.

[Grafana Linux Dashboard for Node-Exporter](https://grafana.com/grafana/dashboards/1860-node-exporter-full)

[Grafana Docker/K8s Dashboard for cAdvisor](https://grafana.com/grafana/dashboards/14841-docker-monitoring)

[Grafana Docker/K8s Dashboard for cAdvisor](https://grafana.com/grafana/dashboards/15798-docker-monitoring)


In my example:
- Automatic configuration of nginx config files for Grafana and Proemteus web servers
- Adjusting access at the level of network rules Nginx
- Optimal Setup Manifest
- Optimal general configuration of nodes
- Deployment automation and security
- Minimal or no manual work


All you need to do to install Prometheus:
- My installed nginx-le image
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Move configuration files from the mounted volume prometheus_nginx_conf and grafana_nginx_conf to the volume with the nginx configuration files of the nginx container:
  service* file to conf.d-le directory
  stream* file to stream.d-le directory
- Reboot Nginx container for apply configs
- Follow the instructions from the official Prometheus source for personalized service settings



Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |
| LE_FQDN                     | -, Domain address     | FQDN*                                    |
| CONTAINER_ALIAS             | -, Zone Name          | C_ALIAS*                                 |
| SERVER_ALIAS                | -, Container address  | S_ALIAS*                                 |

Commands:

```bash
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/conf/service-*.conf /var/lib/docker/volumes/nginx_data/_data/conf.d-le && \
sudo sleep 30 && sudo cp /var/lib/docker/volumes/*nginx_conf/_data/stream/stream-*.conf /var/lib/docker/volumes/nginx_data/_data/stream.d-le && \
docker restart nginx && \
sudo sleep 30 && docker exec -it nginx nginx -t

# To check the Prometheus configuration file
docker exec -it prometheus promtool check config /etc/prometheus/prometheus.yml
```
