# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the contents of your local directory to the container's working directory
COPY . /app

# Install any required dependencies
RUN pip install -r /app/noted/requirements.txt  # If you have a requirements file

# Specify the command to run your NLP model
CMD ["python", "trainmodel.py"]
