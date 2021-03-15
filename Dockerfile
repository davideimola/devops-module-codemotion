FROM debian:stable as builder
WORKDIR /app

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  git ca-certificates asciidoc curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Download and install hugo
ENV HUGO_VERSION 0.81.0
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

RUN curl -sL -o /tmp/hugo.deb \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} \
    && dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb 

COPY . .

RUN hugo -v --minify

FROM nginx:alpine

COPY --from=builder /app/public /usr/share/nginx/html