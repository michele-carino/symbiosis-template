FROM curlimages/curl:latest

# Models config
COPY models.csv /models.txt
COPY init-models.sh /init-models.sh

# Continue.dev config file files
COPY continue.dev/config.sh /continue.dev/config.sh
COPY continue.dev/config.json /continue.dev/config.json

USER root
RUN chmod +x /init-models.sh
RUN chmod +x /continue.dev/config.sh

ENTRYPOINT ["sh", "/init-models.sh"]