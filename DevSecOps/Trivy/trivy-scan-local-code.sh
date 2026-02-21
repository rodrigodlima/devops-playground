#!/bin/bash
docker run --rm -v ../../runtime-vs-buildtime/nextjs-example:/scan trivy-scanner fs /scan
#docker run --rm trivy-scanner repo https://github.com/org/repo
