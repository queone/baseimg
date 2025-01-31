# Build image locally with:
#   docker build -f Dockerfile --no-cache -t local-cntimage:latest .

# Use AlmaLinux minimal image as the base
FROM almalinux/9-minimal

ADD requirements.txt /app/requirements.txt

# Install essential tools (customize as needed)
COPY layer1.sh /tmp/layer1.sh
RUN /bin/bash /tmp/layer1.sh

# Set working directory
WORKDIR /app

# Add your application code or setup here
#COPY . /app

CMD ["bash"]
