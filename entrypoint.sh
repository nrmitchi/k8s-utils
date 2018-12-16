#!/bin/sh

# Template the kubeconfig file
mkdir ~/.kube
sed "s|\${api-server}|${K8S_API_SERVER}|g" /kubeconfig-template > ~/.kube/config
sed -i "s|\${token}|${K8S_TOKEN}|g" ~/.kube/config
sed -i "s|\${certificate-authority-data}|${K8S_CERTIFICATE_AUTHORITY_DATA}|g" ~/.kube/config

# Template the aws credentials file
mkdir ~/.aws
sed "s|\${aws-access-key-id}|${AWS_ACCESS_KEY_ID}|g" /awscredentials-template > ~/.aws/credentials
sed -i "s|\${aws-secret-access-key}|${AWS_SECRET_ACCESS_KEY}|g" ~/.aws/credentials

# Template the aws config file
AWS_REGION=${AWS_REGION:-us-east-1}
sed "s|\${aws-region}|${AWS_REGION}|g" /awsconfig-template > ~/.aws/config

# Run the command that was passed at "docker run". Using exec will make the command have the PID 1.
# See https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#entrypoint
exec "$@"
