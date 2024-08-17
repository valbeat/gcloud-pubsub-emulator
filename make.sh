#!/usr/bin/env bash

set -e

docker build -t gcloud-pubsub-emulator:latest .
docker tag gcloud-pubsub-emulator valbeat/gcloud-pubsub-emulator:latest
docker push docker.io/valbeat/gcloud-pubsub-emulator:latest
docker push docker.io/valbeat/gcloud-pubsub-emulator:latest
