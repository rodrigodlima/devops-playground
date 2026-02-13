FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        sshpass \
        openssh-client \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir ansible

WORKDIR /workspace
