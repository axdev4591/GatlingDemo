#!/bin/bash

# Run gatling load test
echo "Run gatling load tests."
mvn gatling:test '-Dclassname=com.gatling.tests.computerSimulation'


