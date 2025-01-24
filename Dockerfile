# Use AlmaLinux minimal image as the base
FROM almalinux:9-minimal

COPY layer1.sh /tmp/layer1.sh

# Install essential tools (customize as needed)
RUN /bin/bash /tmp/layer1.sh

# Set working directory
WORKDIR /app

# Add your application code or setup here
#COPY . /app

CMD ["bash"]
