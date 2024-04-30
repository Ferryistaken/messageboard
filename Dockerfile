FROM fedora:latest

# Install necessary tools
RUN dnf install -y nc socat cronie

# Create the directory structure for the messageboard
WORKDIR /app/messageboard
RUN mkdir -p log backups

# Copy the existing scripts and files
COPY log/header.txt log/header.txt
COPY log/footer.txt log/footer.txt
COPY web.sh .
COPY server.sh .
COPY backup.sh .

# Make the scripts executable
RUN chmod +x web.sh server.sh backup.sh

# Setup cron job for backup.sh
RUN echo "0 0 * * * /app/messageboard/backup.sh" > /etc/crontab

# Start cron along with the server and web scripts
CMD crond && ./server.sh & ./web.sh
