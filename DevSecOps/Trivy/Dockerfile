FROM aquasec/trivy:latest

ENTRYPOINT ["trivy"]
CMD ["image", "--severity", "HIGH,CRITICAL", "--exit-code", "1", "alpine:latest"]
