# syntax=docker/dockerfile:1
FROM ghcr.io/romange/ubuntu-dev:20 as builder

# Set the target platform argument
ARG TARGETPLATFORM

# Set the working directory for the build stage
WORKDIR /build

# Clone the DragonflyDB project directly into the /build directory
RUN git clone --recursive https://github.com/dragonflydb/dragonfly /dragonfly

# Copy the fetch_release.sh script and releases from the cloned repository
COPY /dragonfly/tools/docker/fetch_release.sh /tmp/
COPY /dragonfly/releases/dragonfly-* /tmp/

# Run the fetch_release script to download the necessary files
RUN /tmp/fetch_release.sh ${TARGETPLATFORM}

# Now create the production image
FROM ubuntu:22.04

# Set environment variables
ARG QEMU_CPU
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat-openbsd \
    ca-certificates \
    redis-tools \
    net-tools \
    git \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Create user and group for running DragonflyDB
RUN groupadd -r -g 999 dfly && useradd -r -g dfly -u 999 dfly

# Create a directory for data and set ownership
RUN mkdir /data && chown dfly:dfly /data

# Define the volume and working directory
VOLUME /data
WORKDIR /data

# Copy entrypoint and healthcheck scripts from the cloned repository
COPY /dragonfly/tools/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY /dragonfly/tools/docker/healthcheck.sh /usr/local/bin/healthcheck.sh

# Copy the built DragonflyDB binary from the builder stage
COPY --from=builder /build/dragonfly/build-opt/dragonfly /usr/local/bin/

# Set healthcheck command
HEALTHCHECK CMD /usr/local/bin/healthcheck.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port for inter-container communication
EXPOSE 6379

# Command to run DragonflyDB
CMD ["dragonfly", "--logtostderr"]
