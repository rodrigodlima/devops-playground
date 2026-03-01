# Intentionally vulnerable Dockerfile for demo purposes
FROM python:3.8-slim

# Running as root (bad practice)
USER root

# Outdated and vulnerable packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Exposing sensitive port
EXPOSE 22
EXPOSE 8080

CMD ["python", "app.py"]
