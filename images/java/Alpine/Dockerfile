# ---- Build Stage ----
FROM maven:3.9.4-eclipse-temurin-17-alpine AS build

# Set the current working directory inside the image
WORKDIR /app

# Copy maven executable to the image
COPY ../code/mvnw .
COPY ../code/.mvn .mvn

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
FROM eclipse-temurin:17-jre-alpine

# Create the "limitedaccessgroup" group
RUN addgroup limitedaccessgroup

# Create a non-root user named "limitedaccessaccount" with a specific user ID (e.g., 1050)
# and add it to the "limitedaccessgroup" group
RUN adduser -D -G limitedaccessgroup -u 1050 limitedaccessaccount

# Specify the work directory and set permissions
WORKDIR /app
RUN chown limitedaccessaccount:limitedaccessgroup /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Set non-root user
USER limitedaccessaccount

# Expose the port that the Spring Boot application will run on (default is 8080)
EXPOSE 8080

# Specify the entrypoint command to run on container start
ENTRYPOINT ["java", "-jar", "app.jar"]