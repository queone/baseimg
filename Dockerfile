# Build image locally with:
#   docker build --no-cache -t local-ubi9:x.x.x .

# Use AlmaLinux minimal image as the base
FROM almalinux/9-minimal

# Install essential tools (customize as needed)
COPY layer1.sh /tmp/layer1.sh
RUN /bin/bash /tmp/layer1.sh

# Set working directory
WORKDIR /app

# Add your application code or setup here
#COPY . /app

CMD ["bash"]
