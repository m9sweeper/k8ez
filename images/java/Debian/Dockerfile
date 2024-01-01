# ---- Build Stage ----
FROM maven:3.9.4-amazoncorretto-17-debian AS build

# Set the current working directory inside the image
WORKDIR /app

# Copy the pom.xml file
COPY ../code/pom.xml .

# Build all the dependencies in preparation to go offline.
# This is a separate step so the dependencies will be cached unless
# the pom.xml file has changed.
RUN mvn dependency:go-offline -B

# Copy the project source
COPY ../code/ .

# Package the application
RUN mvn package -DskipTests

# ---- Run Stage ----
FROM eclipse-temurin:17-jre

# Create a group and a non root user
RUN groupadd -g 1000 appgroup && \
    useradd -m -u 1000 -g appgroup -s /bin/bash appuser


# Specify the work directory and set permissions
WORKDIR /app
RUN chown appuser:appgroup /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Change to non-root user
USER 1000

# Expose the port that the Spring Boot application will run on (default is 8080)
EXPOSE 8080

# Specify the entrypoint command to run on container start
ENTRYPOINT ["java", "-jar", "app.jar"]
