# Add python image to be used as base image
FROM python:3.12-slim
# Set the working directory in the container
WORKDIR /app
# Copy the requirements file to the working directory
COPY requirements.txt .
# Install the dependencies from the requirements file
RUN pip install --no-cache-dir -r requirements.txt
# Copy the rest of the application code to the working directory
COPY . .
# Expose the port that the application will run on
EXPOSE 5000       
# Command to run the application 
CMD ["flask", "run", "--host=0.0.0.0"]  

