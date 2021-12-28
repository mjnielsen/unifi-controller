FROM debian:buster-20201012-slim

RUN apt-get update && apt-get install wget ca-certificates apt-transport-https gnupg -y

# Install libssl1.0.0 required by MongoDB
COPY libssl.sh /tmp/
RUN chmod +x /tmp/libssl.sh && /tmp/libssl.sh

# Install MongoDB 3.6
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.6.asc | apt-key add - \
    && echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse' >> /etc/apt/sources.list \
    && apt-get update && apt-get install mongodb-org-server -y

# Install openjdk-8
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' >> /etc/apt/sources.list \
    && mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install adoptopenjdk-8-hotspot -y

# Install Unifi Controller
RUN apt-get update && apt-get install logrotate binutils libcap2 curl jsvc -y \
    && wget https://dl.ui.com/unifi/6.5.55/unifi_sysvinit_all.deb && dpkg -i unifi_sysvinit_all.deb \
    && mkdir -p /usr/lib/unifi/data && touch /usr/lib/unifi/data/system.properties \
    && rm unifi_sysvinit_all.deb

EXPOSE 3478/udp 5514/udp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 6789/tcp 27117/tcp 5656-5699/tcp 10001/udp 1900/udp

CMD ["java", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
