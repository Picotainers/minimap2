# Use an intermediate image to build minimap2
FROM debian:bullseye-slim AS builder

RUN apt-get update && \
   apt-get install -y git make gcc zlib1g-dev upx-ucl


RUN git clone https://github.com/lh3/minimap2 && \
     \    
    cd minimap2 && \
    sed -i '/^CFLAGS=/c\CFLAGS=		-g -Wall -O2 -Wc++-compat -static' Makefile &&\
    make && \
    strip minimap2 && \
    upx minimap2



# Use a distroless base image
FROM gcr.io/distroless/base

# Copy the minimap2 binary from the builder image
COPY --from=builder /minimap2/minimap2 /usr/local/bin/minimap2
#COPY minimap2 /usr/local/bin/minimap2
# Set the entrypoint to the static minimap2 binary
ENTRYPOINT ["/usr/local/bin/minimap2"]
