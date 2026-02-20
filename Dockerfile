ARG REGISTRY

FROM ${REGISTRY}node:22.14.0 AS build

# Set working directory for entire container
WORKDIR /usr/src/app

# Copy package.json first, so we can properly cache the layer.
COPY package*.json /usr/src/app/

# Copy Sources.
COPY . .

# Build production app
RUN npm run build  -- --output-path dist/ggc-test

# Create actual container
FROM ${REGISTRY}nginxinc/nginx-unprivileged:1.25-alpine

# Set Main Workdir
WORKDIR /etc/nginx/html/

USER root
RUN adduser --home /etc/ggc-test --disabled-password --gecos "" ggc-test

# Copy compiled Application sources
COPY --chown=ggc-test:ggc-test --from=build /usr/src/app/dist/ggc-test /etc/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf
COPY startup/start-application.sh /var/appdata/run/start-application.sh

# Create cache directories
RUN mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/cache/nginx/uwsgi_temp && \
    mkdir -p /var/cache/nginx/proxy_temp && \
    mkdir -p /var/cache/nginx/fastcgi_temp && \
    mkdir -p /var/cache/nginx/scgi_temp && \
    mkdir -p /var/cache/nginx/uwsgi_temp

# Create log directory and file, set permissions
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/error.log && \
    chown -R ggc-test:ggc-test /var/log/nginx && \
    chown -R ggc-test:ggc-test /etc/nginx/html/

# Permissions adjustments
RUN chown -R ggc-test:ggc-test /var/cache/nginx/ /var/appdata/run /etc/nginx/html/ /tmp && \
    chmod +x /var/appdata/run/start-application.sh

RUN chmod -R a+rw /etc/nginx/html/ /tmp

EXPOSE 8080
USER ggc-test

# Force entrypoint, used to do some environment variable magic, and precompile the Angular Environment Files.
ENTRYPOINT [ "/var/appdata/run/start-application.sh"]
