# Simple production-ready Dockerfile for the Flask app
# Uses a small Python base image
FROM python:3.11-slim

# Ensure Python doesn’t buffer stdout/stderr and writes bytecode is disabled
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install runtime deps (curl for debugging/healthchecks if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -ms /bin/bash appuser
WORKDIR /app

# Install dependencies first (leverage Docker layer caching)
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . /app

# Expose Flask port
EXPOSE 5000

# Switch to non-root
USER appuser

# Default command: run the Flask app
CMD ["python", "deployments/python/hello_world.py"]
