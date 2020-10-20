FROM debian:buster-20201012-slim

COPY libssl.sh /tmp/
# COPY unifi_sysvinit_all.deb /tmp/

RUN apt-get update && apt-get install wget ca-certificates apt-transport-https gnupg -y
RUN chmod +x /tmp/libssl.sh && /tmp/libssl.sh

# Install MongoDB 3.6
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.6.asc | apt-key add - 
RUN echo 'deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main' >> /etc/apt/sources.list 
RUN apt-get update && apt-get install mongodb-org-server -y

# Install openjdk-8
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' >> /etc/apt/sources.list
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install adoptopenjdk-8-hotspot -y

# Install Unifi Controller
RUN apt-get update && apt-get install logrotate binutils libcap2 curl jsvc -y
RUN wget https://dl.ui.com/unifi/6.0.28/unifi_sysvinit_all.deb && dpkg -i unifi_sysvinit_all.deb
RUN mkdir -p /usr/lib/unifi/data && touch /usr/lib/unifi/data/system.properties

# Clean up
RUN rm /tmp/libssl.sh && rm unifi_sysvinit_all.deb
RUN apt-get clean

EXPOSE 3478/udp 5514/udp 8080/tcp 8443/tcp 8880/tcp 8843/tcp 6789/tcp 27117/tcp 5656-5699/tcp 10001/udp 1900/udp

CMD ["java", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]