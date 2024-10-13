FROM atlassian/jira-software

USER root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-jira.conf /data/nginx/conf/service-jira.conf
COPY settings/stream/stream-jira.conf /data/nginx/stream/stream-jira.conf

CMD ["/entrypoint.sh"]

USER jira

ENTRYPOINT ["/entrypoint.py", "/usr/bin/tini", "--"]
