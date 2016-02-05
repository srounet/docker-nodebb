FROM debian:8.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# System requirements
RUN apt-get install -y supervisor wget build-essential git

# redis
RUN cd /tmp && wget http://download.redis.io/redis-stable.tar.gz && tar xvzf redis-stable.tar.gz
RUN cd /tmp/redis-stable && make && make install
RUN cp -f /tmp/redis-stable/src/redis-sentinel /usr/local/bin
RUN mkdir -p /etc/redis && cp -f /tmp/redis-stable/*.conf /etc/redis && rm -rf /tmp/redis-stable*
RUN sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(dir .*\)$/# \1\ndir \/data\/redis/' /etc/redis/redis.conf && \
    sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

# Nodejs requirements
RUN apt-get install -y nodejs nodejs-legacy npm 

# nodebb
RUN apt-get install imagemagick -y
RUN git clone  https://github.com/NodeBB/NodeBB /opt/nodebb
RUN cd /opt/nodebb && npm install --production

# email
RUN apt-get install -y postfix
RUN cd /opt/nodebb && npm install nodebb-plugin-emailer-ssl-smtp
RUN cd /opt/nodebb && npm install nodebb-plugin-emailer-local
RUN cd /opt/nodebb && npm install nodebb-plugin-dbsearch

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY run-nodebb.sh /sbin/run-nodebb.sh
COPY run-redis.sh /sbin/run-redis.sh
# COPY config.json /opt/nodebb/config.json

RUN chmod 755 /sbin/run-nodebb.sh
RUN chmod 755 /sbin/run-redis.sh


EXPOSE 4567

VOLUME /data
VOLUME /opt/nodebb

CMD ["supervisord", "-n"]
