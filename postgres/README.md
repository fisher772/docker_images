# DB PostgreSQL. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/postgres?logo=github)](https://github.com/fisher772/postgres/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/postgres)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/postgres/pkgs/container/postgres)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/postgres)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.

PostgreSQL, is an object-relational database management system (ORDBMS) with an emphasis on extensibility and standards-compliance. As a database server, its primary function is to store data, securely and supporting best practices, and retrieve it later, as requested by other software applications, be it those on the same computer or those running on another computer across a network (including the Internet). It can handle workloads ranging from small single-machine applications to large Internet-facing applications with many concurrent users. Recent versions also provide replication of the database itself for security and scalability.

[PostgreSQL reference docs](https://help.sonatype.com/en/sonatype-nexus-repository.html)
[PostgreSQL official page](https://www.postgresql.org)

Why do I need a PostgreSQL?
- Storing Private Artifacts
- Caching Artifacts
- Scalability
- Cross-Platform Support
- Free and Open-Source

My small image was created to automate database installation and give flexibility in creating multiple databases and corresponding users in PostgreSQL from environment variables.

All you need to do to install PostgreSQL:
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest
- Follow the instructions from the official Nexus source for personalized service settings


Environment:

|  Environment                | Default value         | Customize (env variable)\*\*             |
| --------------------------- | --------------------- | ---------------------------------------- |
| POSTGRES_MULTIPLE_DATABASES | -, Singe or Multi DB  | DB_MULTIPLE                              |
| POSTGRES_USER               | '/', SuperUser-DB     | DB_USER                                  |
| POSTGRES_PASSWORD           | -, SuperUserPW-DB     | DB_PASSWORD                              |
