FROM python:3.11-alpine

# Use root user to install packages
USER root

# Update package list and install necessary packages
RUN apk update && \
    apk add --no-cache espeak-ng ffmpeg

# Set the working directory
WORKDIR /app

# Set environment variable for NLTK data
ENV NLTK_DATA=/app/nltk_data

# Create the NLTK data directory
RUN mkdir -p ${NLTK_DATA}
RUN mkdir -p /app/tmp

# Create a non-root user and switch to it
RUN adduser -D -h /app appuser && chown -R appuser /app
USER appuser

# Copy the application code
COPY epub2tts_edge /app/epub2tts_edge
COPY requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Download NLTK data
RUN python -m nltk.downloader -d ${NLTK_DATA} punkt

# Set the command to run the application
CMD ["python", "/app/epub2tts_edge/epub2tts_edge.py"]