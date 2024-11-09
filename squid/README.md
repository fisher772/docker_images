# Squid. IAC

[![GitHub](https://img.shields.io/github/v/release/fisher772/squid?logo=github)](https://github.com/fisher772/squid/releases)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Repo)](https://github.com/fisher772/squid)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue%3Flogo%3Dgithub?logo=github&label=GitHub%20Multi-Repo)](https://github.com/fisher772/docker_images)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-red%3Flogo%3Dgithub?logo=github&label=GitHub%20Ansible-Repo)](https://github.com/fisher772/ansible)
[![GitHub Registry](https://img.shields.io/badge/ghrc.io-Registry-green?logo=github)](https://github.com/fisher772/squid/pkgs/container/squid)
[![Docker Registry](https://img.shields.io/badge/docker.io-Registry-green?logo=docker&logoColor=white&labelColor=blue)](https://hub.docker.com/r/fisher772/squid)

## All links, pointers and hints are reflected in the overview

\* You can use Ansible templates and ready-made CI/CD patterns for Jenkins and GitHub Action. 
Almost every repository contains pipeline patternsю Also integrated into the Ansible agent pipeline using its templates.


Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator. It runs on most available operating systems, including Windows and is licensed under the GNU GPL.

Why do I need a Squid?
- Proxy Service
- Supported protocols, application protocols: HTTP, HTTPS, FTP, ICP, HTCP
- Content Caching. Content Filtering
- Access Control
- Performance Optimization
- Load Balancing
- Anonymity and Privacy
- Bandwidth Management
- Free and Open-Source
- For example, you can also use Squid to proxy traffic to torrents or for Telegram services
- To interact with any restricted services or sources of information from any of the parties (Provider or Resource itself) within the supported protocols on the Squid side (HTTP, HTTPS, FTP, ICP, HTCP). We encrypt and mask our traffic from home, laboratory or small enterprise
- We can use a multi-level approach with multiple VPN (you can also read about installing it in my git repository) host entry points or additionally route traffic through SQUID to eliminate breadcrumbs
- Use at the router level (for example, Keenetic) to unlock your favorite services or information sources without using clients or repeatedly creating a connection profile on different devices. It is also easier to share a Wi-Fi hotspot with a guest than to disclose or collect new access for the guest.
\* An example of using a router as an proxy-client that will act as a gateway for connecting clients in a Wi-Fi coverage area or LAN network. The traffic of these clients will be directed to your Proxy
\*\* [KEENETIC MANUAL](https://help.keenetic.com/hc/ru/articles/7474374790300-%D0%9A%D0%BB%D0%B8%D0%B5%D0%BD%D1%82-%D0%BF%D1%80%D0%BE%D0%BA%D1%81%D0%B8)


This image automates the process of manual preparation, service configuration and deployment. It also follows Sec and Ops practices.

What work has been done:
- Automatic server configuration based on input variables that you define in the docker manifest. For example, using HTTP/HTTPS protocols and, accordingly, using certificates for HTTPS connections provided by you. Also, regulating access at the rule level from a pool of specified IP addresses specified by you. Specifying ports convenient for you for HTTP/HTTPS connections.
- Automatic generation of arbitrary connection profiles for Proxy. These accesses can also be recreated or a number of new profiles can be formed. For your convenience, all accesses will be saved in a flat file.
- Connections are configured at a non-concurrent level, at "Asynchronous/Parallelized level" so that you can use one access profile with multiple devices or different networks.
- Adjusted optimal configuration settings for inactive session timeout
- Logging has been configured

All you need to do to install Squid:
- Specify your network parameters in docker manifest
- Change the env_example file to .env and set the variable values ​​in the .env file.
- Have free resources on the host/hosts
- Deploy docker compose manifest

Environment:

A more detailed explanation of the variables can be found in the git repository: squid/env_example


Commands:

```bash
# Re-creating the connection profile configuration
sudo sleep 30 && docker exec -it ./entrypoint.sh --rewrite_creds

# To create new access profiles
sudo sleep 30 && docker exec -it ./entrypoint.sh --adduser
```

\* Flat files with accesses can be viewed inside the container: /etc/squid/user_creds/*.txt
\*\* Or inside a mounted volume on the host: volumes: data
