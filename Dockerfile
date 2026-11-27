# syntax=docker/dockerfile:1

# ---- 1. Build the React single-page app -------------------------------------------------------
FROM node:26-alpine AS frontend
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi
COPY frontend/ ./
RUN npm run build

# ---- 2. Build the Spring Boot jar with the SPA bundled as static resources --------------------
FROM eclipse-temurin:25-jdk-alpine AS backend
WORKDIR /app/backend
COPY backend/.mvn .mvn
COPY backend/mvnw backend/pom.xml ./
RUN chmod +x mvnw && ./mvnw -B -q dependency:go-offline
COPY backend/src src
COPY --from=frontend /app/frontend/dist src/main/resources/static
RUN ./mvnw -B -q package -DskipTests

# ---- 3. Minimal runtime image -----------------------------------------------------------------
FROM eclipse-temurin:25-jre-alpine
RUN addgroup -S tasklane && adduser -S tasklane -G tasklane
WORKDIR /app
COPY --from=backend /app/backend/target/tasklane-*.jar app.jar
USER tasklane
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=3s --start-period=40s --retries=5 \
  CMD wget -qO- http://localhost:8080/actuator/health/liveness || exit 1
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "/app/app.jar"]
