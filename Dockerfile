FROM registry.fedoraproject.org/fedora-minimal:latest
ADD ./install-cadquery.sh /install-cadquery.sh
RUN bash /install-cadquery.sh
ADD ./entrypoint.sh /entrypoint.sh
ADD ./settings.json /root/.local/share/code-server/User/settings.json
ADD ./launch.json /root/.local/share/code-server/User/launch.json

VOLUME /data
WORKDIR /data
EXPOSE 8080

CMD ["/bin/bash", "/entrypoint.sh"]
