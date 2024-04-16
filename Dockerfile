# Use Ubuntu as base image
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

ARG APPDIR=/app

# Make App directory
RUN mkdir -p $APPDIR
WORKDIR $APPDIR

# Copy scripts
COPY scripts ./scripts
RUN chmod +x ./scripts -R

# Copy extensions
COPY modules/additional-packages.txt additional-packages.txt
COPY modules/php-extensions.txt php-extensions.txt

# Run Setup
RUN ["/bin/bash", "-c", "$APPDIR/scripts/setup.sh"]

# Start Apache in the foreground
CMD ["/bin/bash","-c","/app/scripts/app.sh"]
