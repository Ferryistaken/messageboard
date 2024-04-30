# Messageboard

> live demo: [message.alessandroferrari.live](https://message.alessandroferrari.live)

This project uses simple Bash scripts to create a message logging and display system running inside a Docker container. The system consists of a message server script (`server.sh`) that listens for and logs messages, a web server script (`web.sh`) that serves the messages through a simple web interface, and a backup script (`backup.sh`) that performs daily backups of the messages.

## Quick Start

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Ferryistaken/messageboard
   cd messageboard
   ```

2. **Build the Docker Container:**
   ```bash
   docker build -t messageboard .
   ```

3. **Run the Container:**
   ```bash
   docker run -dp 6969:6969 -dp 1915:1915 messageboard
   ```

   > This command runs the Docker container and maps the ports 6969 (web server) and 1915 (message server) to the host.

4. **Access the Messageboard:**
   - Send messages to the server: `nc [Your-Container-IP] 1915`
   - View messages via a web browser: `http://[Your-Container-IP]:6969`

## Components

- **web.sh**: Serves logged messages along with custom header and footer via HTTP on port 6969.
- **server.sh**: Listens on port 1915 for incoming messages, logs them to a file, and supports basic interaction.
- **backup.sh**: Runs daily to backup the messages log to a dedicated backup directory.

## Customization

- Default ports and file paths can be customized using environment variables (`PORT` for `web.sh` and `PORT_SERVER` for `server.sh`).
- Header and footer text can be modified in `header.txt` and `footer.txt` respectively.

## Logs and Backups

Logs are stored in `/app/messageboard/log/messages.log` and daily backups are stored in `/app/messageboard/log/backups`.

