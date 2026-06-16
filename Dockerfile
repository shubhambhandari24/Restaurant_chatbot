# ─────────────────────────────────────────────────────────────────────────────
# Stage 1: Build the WAR with Maven
# ─────────────────────────────────────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy POM first (layer-cache friendly — only re-downloads deps if pom.xml changes)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ─────────────────────────────────────────────────────────────────────────────
# Stage 2: Deploy WAR into Tomcat 10 (Jakarta EE compatible)
# ─────────────────────────────────────────────────────────────────────────────
FROM tomcat:10.1-jdk21-temurin

# Remove default Tomcat apps to keep it clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy our WAR as ROOT.war so it's served at / (not /restaurant-chatbot)
COPY --from=builder /app/target/restaurant-chatbot.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
