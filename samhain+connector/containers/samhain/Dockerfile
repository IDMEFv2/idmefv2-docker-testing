# Dockerfile for Samhain HIDS
FROM debian:bullseye-slim

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    gnupg \
    libgmp-dev \
    zlib1g-dev \
    libssl-dev \
    libpcre3-dev \
    procps \
    vim \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Download and compile Samhain
WORKDIR /tmp
RUN wget https://la-samhna.de/samhain/samhain-current.tar.gz \
    && tar xzf samhain-current.tar.gz \
    && rm samhain-current.tar.gz \
    && ls -la \
    && tar xzf samhain-*.tar.gz \
    && rm samhain-*.tar.gz \
    && cd samhain-*/ \
    && ./configure \
        --enable-login-watch \
        --enable-suidcheck \
        --enable-process-check \
        --enable-port-check \
        --with-log-file=/var/log/samhain/samhain.log \
        --with-pid-file=/var/run/samhain.pid \
        --with-data-file=/var/lib/samhain/samhain_file \
        --with-config-file=/etc/samhain/samhainrc \
    && make \
    && make install \
    && cd .. \
    && rm -rf samhain-*/

# Create required directories
RUN mkdir -p /var/log/samhain \
    && mkdir -p /var/lib/samhain \
    && mkdir -p /etc/samhain \
    && mkdir -p /monitored

# Create directory for test files to monitor
RUN mkdir -p /monitored/sensitive \
    && echo "Original sensitive file" > /monitored/sensitive/config.txt \
    && echo "Simulated password file" > /monitored/sensitive/passwords.txt \
    && echo "Critical system file" > /monitored/sensitive/system.conf \
    && chmod 600 /monitored/sensitive/*

# Copy custom configuration
COPY samhainrc /etc/samhain/samhainrc

# Copy initialization script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy script to simulate alerts
COPY simulate_alerts.sh /simulate_alerts.sh
RUN chmod +x /simulate_alerts.sh

# Volume for logs
VOLUME ["/var/log/samhain"]

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
