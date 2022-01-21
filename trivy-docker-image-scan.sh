#!/bin/bash
dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.22.0 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

# Trivy scan result processing
exit_code=$?
echo "Exit Code : $exit_code"

# Check scan results
if [[ "${exit_code}" == 1 ]]; then
    echo "Image scanning failed. Vulnerabilities found, not failing build"
    echo "---------------------------------------------------------------"
    echo "Please fix the vulnerabilities"
    exit 0;
else
    echo "Image scanning passed. No CRITICAL vulnerabilities found"
fi;