#!/bin/bash

echo "This just a test running in gatlin container"
# "docker run --rm -t -v vol1GatData:/var/lib/gatling gatling-runner -r ${AWS_REPORT_BUCKET} -p ${PROFILE}"