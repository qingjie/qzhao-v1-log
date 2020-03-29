#!/bin/bash

set -x

export PROFILES=${PROFILES:-dev}

java -Xmx200m -jar -Dspring.profiles.active=${PROFILES} /app/qzhao-v1-log-1.0.0.jar
