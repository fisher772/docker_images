# Grafana. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/kibana?logo=github)](https://github.com/fisher772/kibana/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/kibana)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Nginx-Repo)](https://github.com/fisher772/nginx-le)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Prometheus-Repo)](https://github.com/fisher772/prometheus)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/kibana/pkgs/container/kibana)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/kibana)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.


[Grafana official page](https://grafana.com/grafana)
[Grafana reference docs](https://grafana.com/docs/grafana/latest)

Grafana is an open-source analytics and interactive visualization web application used for monitoring application performance. It allows users to ingest data from a wide range of sources, query and display it in customizable charts, set alerts for abnormal behavior, and visualize data on dashboards.

Since Grafana is an ambassador in metrics visualization. You can thus immerse yourself in a long and exciting process of creating your dashboards, but whether it is necessary is up to you.

There are official and custom ready-made dashboards for different solutions. I suggest not to reinvent the wheel for standard solutions and use cat solutions for visualization. Service visualization, docker visualization, kubernetes visualization, etc.

[Grafana Linux Dashboard for Node-Exporter](https://grafana.com/grafana/dashboards/1860-node-exporter-full)

[Grafana Docker/K8s Dashboard for cAdvisor](https://grafana.com/grafana/dashboards/14841-docker-monitoring)

[Grafana Docker/K8s Dashboard for cAdvisor](https://grafana.com/grafana/dashboards/15798-docker-monitoring)

Why do I need a Grafana?
- Multi-data source support
- Customizable Dashboards
- Data Visualization
- Alerting Capabilities
- Team Collaboration
- Time Range Control
- Search and Explore
- Performance Optimization
- Integration with other tools(Redis/Loki/Prometheus/Elasticsearch ... etc)

My small fork example generates a configuration files for a reverse proxy balancing nginx which also regulates service availability at the level of service access rules. You can distribute external access to the service or restrict access. Provide access only to off-network users from VPN traffic or external IP addresses specified by you.

All you need to do to install Grafana:
- My installed nginx-le image
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Move configuration files from the mounted volume grafana_nginx_conf to the volume with the nginx configuration files of the nginx container:
  service* file to conf.d-le directory
  stream* file to stream.d-le directory
- Reboot Nginx container for apply configs
- Follow the instructions from the official Grafana source for personalized service settings




Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |
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
