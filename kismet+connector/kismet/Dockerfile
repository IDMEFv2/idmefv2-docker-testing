FROM finchsec/kismet:latest

# Install inotify-tools for file monitoring and curl for healthcheck
RUN apt-get update && apt-get install -y inotify-tools curl && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script
COPY kismet/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script instead of default
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
