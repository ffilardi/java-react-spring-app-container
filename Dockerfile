FROM maven:3.8.5-openjdk-11-slim AS build
ENV MAVEN_CONFIG=''
RUN mkdir -p workspace
WORKDIR /workspace
COPY pom.xml /workspace
COPY package.json /workspace
COPY webpack.config.js /workspace
COPY mvnw /workspace
COPY mvnw.cmd /workspace
COPY src /workspace/src
COPY .mvn /workspace/.mvn
RUN chmod +x ./mvnw
RUN ./mvnw -f pom.xml clean install

FROM openjdk:11-jre-slim
COPY --from=build /workspace/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]