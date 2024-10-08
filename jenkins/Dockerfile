FROM jenkins/jenkins:lts

USER root

COPY --chown=jenkins:jenkins settings/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugins -f /usr/share/jenkins/ref/plugins.txt
RUN rm -rf /var/cache/apt/archives/*

COPY entrypoint.sh /data/entrypoint.sh
RUN chmod +x /data/entrypoint.sh

RUN mkdir -p /data/nginx/stream conf ssl

COPY settings/service-jenkins.conf /data/nginx/conf/service-jenkins.conf
COPY settings/stream/stream-jenkins.conf /data/nginx/stream/stream-jenkins.conf

CMD ["/data/entrypoint.sh"]
