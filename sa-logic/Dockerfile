# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install any dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Download NLTK data
RUN python -m nltk.downloader punkt

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 5000 (if your app runs on this port, adjust if necessary)
EXPOSE 8443

# Specify the command to run the application
CMD ["python", "sentiment_analysis.py"]
