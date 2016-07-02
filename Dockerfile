FROM us.gcr.io/qalorie-1224/qalorie/qalorie_node_base:latest

MAINTAINER Abel Alejandro <abel@aalejandro.com>

COPY . /app/qalorie-backend

RUN cd /app/qalorie-backend/app && \
    npm install && \
    npm install -g grunt-cli && \
    grunt

# Fix permissions                                        
RUN chmod -R 755 /app/qalorie-backend/app/modules/webserver/public/uploads

# Run app
ENTRYPOINT ["/bin/bash", "/run.sh"]


