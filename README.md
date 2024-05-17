![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/zabbix/zabbix-docker/badge)](https://securityscorecards.dev/viewer/?uri=github.com/zabbix/zabbix-docker)
[![OpenSSF Best Practices](https://bestpractices.coreinfrastructure.org/projects/8395/badge)](https://bestpractices.coreinfrastructure.org/projects/8395)

[![Build images (DockerHub)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build.yml/badge.svg?branch=6.4&event=push)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build.yml)
[![Build images (DockerHub, Windows)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build_windows.yml/badge.svg?branch=6.4&event=push)](https://github.com/zabbix/zabbix-docker/actions/workflows/images_build_windows.yml)

### Modified by ahmed elhadidi by collecting from multiple open source repos, Thanks to everyone who's open source code was used here.
# What is Zabbix?

Zabbix is an enterprise-class open source distributed monitoring solution.

Zabbix is software that monitors numerous parameters of a network and the health and integrity of servers. Zabbix uses a flexible notification mechanism that allows users to configure e-mail based alerts for virtually any event. This allows a fast reaction to server problems. Zabbix offers excellent reporting and data visualisation features based on the stored data. This makes Zabbix ideal for capacity planning.

For more information and related downloads for Zabbix components, please visit https://hub.docker.com/u/zabbix/ and https://zabbix.com

# this docker-compose comes equipped with the official ookla speedtest package installed on the service named speedtest with a corn job to run every 5 mins.


## Usage

### Clone the repo
```
git clone https://github.com/AhmedElhadidii/Zabbix-home-Lab-with-Speedtest.git
```

### move to the directory

```
cd Zabbix-home-Lab-with-Speedtest/
```

### Run the Docker-compose Yaml File " the one with the v5"
```
docker-compose -f docker-compose_v5.yaml up -d
```
