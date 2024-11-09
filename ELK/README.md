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


[Elastic reference docs](https://www.elastic.co/docs)

[Redis reference docs](https://redis.io/docs/latest)
[Redis Config reference docs](https://redis.io/docs/latest/operate/oss_and_stack/management/config)

A simple "Monitoring/Observability" example for tracking issues in a "home infrastructure/ecosystem" using ELK stack + Redis in docker containers.
The main goal is to simplify the deployment of centralized monitoring in a containerized environment and minimize manual configuration.

### Why Redis is in ELK:

Elasticsearch (or any search engine) can be an operational nightmare. Indexing can bog down. Searches can take down your cluster. Your data might have be reindexed for a whole variety of reasons.

So the goal of putting Redis in between your event sources and your parsing and processing is to only index/parse as fast as your nodes and database can handle it so you can pull from the event stream instead of having events pushed into your pipeline.

\* If you run "redis_cli monitor", you can see what's going on on your redis server: filebeat sending data and logstash asking for it.


In my example:
- Filebeat is used as "collector-delivery-slave"
- Redis role is a Broker/Cache
- Logstash is used as "ETL"
- Kibana is used as data visualization
- Elasticsearch is used as data storage

All you need to do to install ELK:
- Check mount points in docker compose manifest
- Specify your network parameters in docker manifest
- If you want to use the grok patterns "./settings/logstash/patterns/nginx_pattern" for marking up logs from my example, then the format and markup of ngix logs should be by default (Out of the box). Otherwise, you will have to write your own grok pattern for logs
- Deploy docker compose manifest on the master or deploy Filebeat on the host with ngnix
- Mount the volume with ngix log files in the Filebeat container (Specify your ngix log volume in the manifest)
- Change the env_example file to .env and set a variable password for ElasticSearch in the .env file. Or specify the password in the docker block of the environment manifest (By default, the login is elastic, you can also change it by adding a variable to the manifest for Elasticsearch)
- Have free resources on the host/hosts

After successful installation launch:
- You need to send a self-signed Elasticsearch certificate (Created automatically) to the Logstash container for encrypted and secure communication and data transfer between services
\* You can exclude HTTPS communication between containers and use HTTP, but I do not recommend it. To do this, you need to comment out the field with the path to the certificate in the configuration file "./settings/logstash/patterns/nginx_pattern" and uncomment two fields with the ssl prefix parameter
- Restart the Logstash container
- Generate a token for Kibana in Elasticsearch for synchronization
- Log in to the Kibana web console, create your first indexes and dashboards

Commands you need to communicate with services:
- Pauses script execution for 90 seconds. This allows containers to complete their configuration
- Copying a certificate from an Elasticsearch container
- Changing certificate permissions
- Copying a file to a Logstash container
- Removing a certificate
- Restarting a Logstash container

Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| TZ                          | Auto detect           | EKB                                      |
| LE_FQDN                     | -, Domain address     | FQDN                                     |
| CONTAINER_ALIAS             | -, Zone Name          | C_ALIAS                                  |
| SERVER_ALIAS                | -, Container address  | S_ALIAS                                  |
| *_JAVA_OPTS                 | 1gb, Java heap        | JAVA_OPTS                                |
| ELASTIC_USER                | elastic               | ELS_USER                                 |
| ELASTIC_PASSWORD            | -, Password           | ELS_PW                                   |


```bash
sudo sleep 90 && docker cp elasticsearch:/usr/share/elasticsearch/config/certs/http_ca.crt . && \
sudo chmod 644 http_ca.crt && \ 
docker cp ./http_ca.crt logstash:/usr/share/logstash/config/ && \ 
sudo rm -f http_ca.crt && \
docker restart logstash
```

Checking the status of elasticsearch:

\* The main thing is that the output shows the status value <> "red"
\*\* Example: "status":"green"

```bash
# HTTPS
curl -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} "https://elasticsearch:9200/_cluster/health"

# HTTP
curl -k -u ${ELASTIC_USER}:${ELASTIC_PASSWORD} "https://elasticsearch:9200/_cluster/health"
```
