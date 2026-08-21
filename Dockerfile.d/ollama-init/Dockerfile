FROM curlimages/curl:latest

# Copia scripts e lista modelli direttamente dentro l'immagine
COPY models.txt /models.txt
COPY init-models.sh /init-models.sh

USER root
RUN chmod +x /init-models.sh

ENTRYPOINT ["sh", "/init-models.sh"]