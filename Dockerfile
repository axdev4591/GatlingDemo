
FROM maven:3.8.6-openjdk-8-slim as build

LABEL maintainer="Axel MOUELE <devops4591@gmail.com>"
#ARG TIME_ZONE=Europe/Amsterdam

#RUN apk add -Uuv python less py-pip openssl tzdata
#RUN pip install awscli
#RUN cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

#RUN apk --purge -v del py-pip && \
#    rm /var/cache/apk/*
WORKDIR /build

COPY pom.xml .
#RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline

COPY src/ /build/src
COPY bin/run.sh .

# With the latest scala-maven-plugin, it always wants to download certain libs at runtime without which the build fails
# Hence install with offline option not possible currently
# For root cause, see: https://github.com/davidB/scala-maven-plugin/blob/master/src/main/java/sbt_inc/SbtIncrementalCompiler.java#L219-L226
#RUN mvn -B install
#RUN mvn -B de.qaware.maven:go-offline-maven-plugin:resolve-dependencies
#RUN mvn -B install
RUN mvn gatling:test


RUN ["chmod", "+x", "run.sh"]

ENTRYPOINT ["./run.sh"]

