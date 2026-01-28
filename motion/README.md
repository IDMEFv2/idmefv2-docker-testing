To access /dev/video devices (like a webcam) from a Docker container, you need to map the host's video device to the container using the --device flag.

Key Steps:
Map the device: Use --device=/dev/video0:/dev/video0 in your docker run command or devices: in docker-compose.yml. This grants the container access to the webcam.
Check the correct device: Use v4l2-ctl --list-devices on the host to identify the correct device path (e.g., /dev/video0, /dev/video1).
Fix permissions: If using a non-root user inside the container, add that user to the video group in the Dockerfile:
RUN usermod -a -G video developer

This ensures the user has read/write access to the device file.