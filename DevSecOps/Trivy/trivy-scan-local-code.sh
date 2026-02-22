#!/bin/bash
docker run --rm -v $1:/scan trivy-scanner fs /scan
#docker run --rm trivy-scanner repo https://github.com/org/repo
