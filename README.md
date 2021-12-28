# Unifi Network Application

Unifi Network Application (previously "Unifi Controller") Docker image.

The list of ports that need to be exposed can be found [here](https://help.ui.com/hc/en-us/articles/218506997-UniFi-Ports-Used). Alternatively, you could run in host network mode if you don't have any issues with port clashes.

If not running in host network mode, you need to inform the controller software of the IP address that Unifi devices can use to communicate with the controller. This can be found in Settings > Controller > Controller Hostname/IP.

To run using docker-compose, do something like this:

    version: '3.7'
    
    services:
      unifi:
        image: mjnielsen/unifi-controller
        container_name: unifi
        restart: unless-stopped

        volumes:
          - ./db:/usr/lib/unifi/data/db
          - ./backups:/usr/lib/unifi/data/backup/
          - ./system.properties/:/usr/lib/unifi/data/system.properties

        ports:
          - "8443:8443" # Port used for controller GUI/API as seen in a web browser
          - "3478/udp" # Port used for STUN
          - "5514/udp" # Port used for remote syslog capture
          - "8080/tcp" # Port used for device and controller communication
          - "8880/tcp" # Port used for HTTP portal redirection
          - "8843/tcp" # Port used for HTTPS portal redirection
          - "6789/tcp" # Port used for UniFi mobile speed test
          - "27117/tcp" # Port used for local-bound database communication
          - "5656-5699/tcp" # Ports used by AP-EDU broadcasting
          - "10001/udp" # Port used for device discovery
          - "1900/udp" # Port used for "Make controller discoverable on L2 network" in controller settings
