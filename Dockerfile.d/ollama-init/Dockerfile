# --- BASE STAGE: abstract ---
FROM curlimages/curl:latest AS base

COPY init-models.sh /init-models.sh
COPY continue.dev/config.sh /continue.dev/config.sh
COPY continue.dev/config.yaml /continue.dev/config.yaml

USER root
RUN chmod +x /init-models.sh
RUN chmod +x /continue.dev/config.sh

ENTRYPOINT ["sh", "/init-models.sh"]


# --- STAGE: CPU ---
FROM base AS cpu
COPY models.cpu.csv /models.csv


# --- STAGE: VULKAN ---
FROM base AS vulkan
COPY models.vulkan.csv /models.csv


# --- STAGE: NVIDIA ---
FROM base AS nvidia
COPY models.nvidia.csv /models.csv