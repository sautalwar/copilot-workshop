# API Documentation

This directory contains auto-generated API documentation for the OutFront Workshop OMS.

## How It Works

API docs are **automatically generated** by the [API Documentation workflow](../../.github/workflows/api-docs.yml) every time API-related code is merged to `main`.

The workflow:
1. Builds the Spring Boot application
2. Starts it temporarily
3. Fetches the OpenAPI 3.0 spec from `/v3/api-docs`
4. Saves it as a workflow artifact

## Files

| File | Format | Use Case |
|------|--------|----------|
| `openapi.json` | JSON | Import into Postman, generate client SDKs |
| `openapi.yaml` | YAML | Human-readable, version control friendly |

## How to Use

### View Interactive Docs (Local)
```bash
# Start the app locally
mvn spring-boot:run

# Open Swagger UI in your browser
open http://localhost:8080/swagger-ui.html
```

### Import into Postman
1. Download `openapi.json` from the latest workflow run
2. In Postman: **Import** → **File** → select `openapi.json`
3. All endpoints are ready to test

### Generate Client SDKs
```bash
# Install OpenAPI Generator
npm install -g @openapitools/openapi-generator-cli

# Generate a TypeScript client
openapi-generator-cli generate -i openapi.json -g typescript-fetch -o ./client
```

## Note
These files are generated artifacts — do not edit them manually. Instead, update the controller and model classes in `src/main/java/` and the workflow will regenerate the docs.
