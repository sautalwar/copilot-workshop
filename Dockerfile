# =============================================================================
# Dockerfile for OutFront Workshop OMS (Spring Boot)
# =============================================================================
#
# MULTI-STAGE BUILD:
#   Stage 1 ("build"): Uses the full JDK + Maven to compile the application
#   Stage 2 ("runtime"): Uses only the JRE to run the compiled JAR
#
#   Why? The build stage includes compilers, build tools, and source code —
#   none of which are needed at runtime. By copying only the JAR to a minimal
#   JRE image, we get:
#     - Smaller image (~150MB vs ~400MB)
#     - Smaller attack surface (fewer packages = fewer vulnerabilities)
#     - Faster deployment (less data to transfer)
#
# USAGE:
#   # Build the image
#   docker build -t outfront-workshop .
#
#   # Run the container
#   docker run -p 8080:8080 outfront-workshop
#
#   # Access the application
#   open http://localhost:8080/swagger-ui.html
# =============================================================================

# ---------------------------------------------------------------------------
# Stage 1: Build — Compile the application with Maven
# ---------------------------------------------------------------------------
# eclipse-temurin is Eclipse's free, production-ready OpenJDK distribution.
# Alpine variant keeps the build image small.
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Copy the Maven project file first — this layer is cached unless pom.xml changes.
# This means dependency downloads are cached between builds, which is much faster.
COPY pom.xml .

# Copy the source code
COPY src ./src

# Install Maven and build the JAR
# -DskipTests: Tests should run in CI, not during Docker build
# -B: Batch mode — suppress download progress for cleaner logs
RUN apk add --no-cache maven && mvn clean package -DskipTests -B

# ---------------------------------------------------------------------------
# Stage 2: Runtime — Run the application with minimal JRE
# ---------------------------------------------------------------------------
# JRE-only image — no compiler, no build tools, no source code
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy ONLY the built JAR from the build stage
# Everything else (source code, Maven cache, build tools) is discarded
COPY --from=build /app/target/*.jar app.jar

# Document the port the app listens on (informational — doesn't actually expose it)
EXPOSE 8080

# Run the Spring Boot application
# Using exec form (JSON array) so the Java process receives OS signals properly
ENTRYPOINT ["java", "-jar", "app.jar"]
