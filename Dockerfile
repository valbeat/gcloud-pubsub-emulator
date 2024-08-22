# Build stage
FROM --platform=linux/arm64 golang:alpine as builder

RUN apk update && apk upgrade && apk add --no-cache curl git

RUN curl -s https://raw.githubusercontent.com/eficode/wait-for/master/wait-for -o /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for

RUN go install github.com/prep/pubsubc@latest

###############################################################################

# Final stage using debian base image for compatibility
FROM --platform=linux/arm64 debian:bullseye-slim

# Install required dependencies manually
RUN apt-get update && apt-get install -y \
    openjdk-11-jre-headless \
    netcat \
    curl \
    gnupg \
    python3 && \
    curl -sSL https://sdk.cloud.google.com | bash && \
    /root/google-cloud-sdk/install.sh --quiet && \
    /root/google-cloud-sdk/bin/gcloud components install beta --quiet && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add gcloud to PATH
ENV PATH=$PATH:/root/google-cloud-sdk/bin

COPY --from=builder /usr/bin/wait-for /usr/bin
COPY --from=builder /go/bin/pubsubc   /usr/bin
COPY                run.sh            /run.sh

EXPOSE 8681

CMD ["/bin/bash", "/run.sh"]
