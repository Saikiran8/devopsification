# Use a specific version of OpenJDK as the base image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the target directory to the working directory inside the container
COPY target/sentiment-analysis-web-0.0.1-SNAPSHOT.jar /app/sentiment-analysis-web-0.0.1-SNAPSHOT.jar

# Set environment variables
ENV SA_LOGIC_API_URL=http://sa-python:8443

# Specify the command to run the application
CMD ["java", "-jar", "sentiment-analysis-web-0.0.1-SNAPSHOT.jar", "--sa.logic.api.url=${SA_LOGIC_API_URL}"]
