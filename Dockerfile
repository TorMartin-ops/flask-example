# Use a lightweight Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install dependencies
# Use --no-cache-dir to save space
# Install build essentials for psycopg2-binary if needed (depends on base image, slim might need them)
# RUN apt-get update && apt-get install -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*
# Based on the output of requirements.txt, psycopg2-binary is used, which might need build tools.
# Let's try without build-essential first, if docker build fails, we can add it.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port that Gunicorn will listen on (default is 8000)
EXPOSE 8000

# Command to run the application using Gunicorn
# The app is assumed to be callable 'app' within wsgi.py
# Use 0.0.0.0 to bind to all interfaces within the container
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "wsgi:app"]

# Note:
# - Ensure your wsgi.py exists and exposes your Flask app instance as 'app'.
# - Ensure all necessary application files are copied by the second COPY . .
# - If building fails due to psycopg2-binary, you might need to uncomment
#   the line installing build-essential and libpq-dev.
