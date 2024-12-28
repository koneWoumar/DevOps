# Use the official FastAPI image
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9-slim

# Set the working directory
WORKDIR /app

# Copy the application code to the container
COPY app.py /app/app.py

# Expose port 8000
EXPOSE 8000

# Command to run the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
