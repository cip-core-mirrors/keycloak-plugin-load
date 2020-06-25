FROM stedolan/jq

USER root

COPY ./manage-plugins.sh /tmp/manage-plugins.sh

RUN chmod +x /tmp/manage-plugins.sh

USER 1001

ENTRYPOINT [ "/tmp/manage-plugins.sh" ]