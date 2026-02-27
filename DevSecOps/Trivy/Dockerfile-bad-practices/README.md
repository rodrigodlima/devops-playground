# Example of Dockerfile bad practices

Here one example of bad practice writing Dockerfile.

```
FROM ubuntu:latest
ENV DB_PASSWORD=supersecret123
RUN apt-get update
```