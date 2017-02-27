FROM steigr/java:8_server-jre_unlimited

ENV  APPLICATION_USER crowd

RUN  addgroup -S $APPLICATION_USER \
 &&  adduser -h /app -G $APPLICATION_USER -g '' -S -D -H $APPLICATION_USER \
 &&  apk add --no-cache --virtual .build-deps tar curl \
 &&  install -D -d -o $APPLICATION_USER -g $APPLICATION_USER /app \
 &&  curl -L https://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-2.11.0.tar.gz \
     | su-exec $APPLICATION_USER tar -x -z -C /app --strip-components=1 \
 && sed -e 's#=.*atlassian-crowd-openid-server\.log#=/app/apache-tomcat/logs/atlassian-crowd-openid-server.log#g' \
        -i /app/crowd-openidserver-webapp/WEB-INF/classes/log4j.properties \
 &&  curl -L http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz \
     | su-exec $APPLICATION_USER tar -x -z -v -C /app/apache-tomcat --strip-components=1 --wildcards 'apache-tomcat-8.5.11/bin/*' 'apache-tomcat-8.5.11/lib/*' \
 &&  sed '/JasperListener/d' -i /app/apache-tomcat/conf/server.xml \
 &&  curl -Lo /app/apache-tomcat/lib/hsqldb-2.3.4.jar http://central.maven.org/maven2/org/hsqldb/hsqldb/2.3.4/hsqldb-2.3.4.jar \
 &&  curl -Lo /app/apache-tomcat/lib/postgresql-42.0.0.jar https://jdbc.postgresql.org/download/postgresql-42.0.0.jar \
 &&  sed -e 's#maxActive#maxTotal#' -i /app/apache-tomcat/conf/Catalina/localhost/crowd.xml \
 &&  sed -e 's#maxActive#maxTotal#' -i /app/apache-tomcat/conf/Catalina/localhost/openidserver.xml \
 &&  apk del .build-deps \
 &&  rm -rf /var/cache/apk/* \
 						/app/licenses /app/start_* /app/stop_* /app/README* /app/build* \
            /app/apache-tomcat/lib/hsqldb-1.8.0.10.jar \
            /app/apache-tomcat/lib/postgresql-9.2-1003-jdbc4.jar

HEALTHCHECK CMD nc -z 127.0.0.1 8095

VOLUME /app/.oracle_jre_usage /app/apache-tomcat/work /app/apache-tomcat/logs /app/database /tmp
ENTRYPOINT ["crowd"]
ADD docker-entrypoint.sh /bin/crowd

ADD scripts/main /main
ADD scripts/vars /vars
ADD scripts/crowd-sso-configurator /crowd-sso-configurator
ADD scripts/crowd-configurator     /crowd-configurator