FROM node:24.14.0 AS build-env
COPY . /app
WORKDIR /app

RUN npm ci --omit=dev

FROM node:24.14.0
COPY --from=build-env /app /app
WORKDIR /app
CMD ["hello.js"]