FROM node:14-buster as builder

WORKDIR /app
COPY package.json package.json
RUN npm install -g grunt && npm install
COPY . .
RUN grunt dist
RUN mkdir -p nginx/samples && mv dist contrib externals node_modules index*js nginx/ && \
        mv samples/dash-if-reference-player-api-metrics-push nginx/samples/dash-if-reference-player-api-metrics-push

FROM nginx:alpine
LABEL maintainer="alessandro.distefano@phd.unict.it"
LABEL author="aleskandro"
LABEL name="MORA-TestBed-Player"
LABEL description="Player with Metrics API handling for MORA"

WORKDIR /usr/share/html
COPY --from=builder /app/nginx .