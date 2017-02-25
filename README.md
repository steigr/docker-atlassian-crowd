# Atlassian Crowd SSO

[![](https://images.microbadger.com/badges/image/steigr/atlassian-crowd.svg)](http://microbadger.com/images/steigr/atlassian-crowd "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/steigr/atlassian-crowd.svg)](http://microbadger.com/images/steigr/atlassian-crowd "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/steigr/atlassian-crowd.svg)](http://microbadger.com/images/steigr/atlassian-crowd "Get your own commit badge on microbadger.com")


- Based on [alpinelinux with Oracle JRE](http://hub.docker.com/r/anapsix/alpine-java)

## Configuration

### Tomcat

Connectors may be configured through the following variable scheme:

`CATALINA_CONNECTOR_x_y` with `x` as positive integer and `y` an uppercase variant of some connector property. The special value `upgrade` for `y` can be empty or `http2` to enable HTTP/2 protocol. See [scripts/vars](scripts/vars) for details.

### Atlassian Crowd

- `CROWD_SERVER_ID` to assign the server id.
- `CROWD_LICENSE` to assign the license string (newlines may be omitted)
- `CROWD_SETUP` (default: `true`) checks if crowd has been setup or automating the setup wizard otherwise.

Support for Crowd is almost complete. For a list of available environment variables see [scripts/vars](scripts/vars).

### Atlassian Crowd SSO

The support for generating `crowd.properties` is implemented but not tested. See [scripts/vars](scripts/vars) for details.

## Example

```shell
# launch crowd web application
docker run --rm \
           --publish=8095:8095 \
           --name=atlassian-crowd \
           --volume=crowd:/crowd \
           steigr/atlassian-crowd
```

## Features

- [x] Install Crowd
- [x] Upgrade Apache Tomcat to 8.5.x for HTTP/2 support
- [x] Bootstrap Crowd automatically
- [x] Support JDBC Database-Connections
- [x] Configure Apache Connectors via environment variables
- [x] Configure Crowd SSO via environment variables
- [ ] Allow passing SSL Certificates and Keys for Tomcat Connectors
- [ ] Use Log4J 2.x
- [ ] Provide Elasticsearch LogAppender
- [ ] Test MySQL connectivity
- [ ] Check JNDI configuration