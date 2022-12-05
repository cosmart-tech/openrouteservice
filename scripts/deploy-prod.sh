#!/bin/bash

## set environment variable to prod
export BUILD_ENV=prod
echo Building image. Environment: $BUILD_ENV

GIT_REF=$(git show -s --format=%h)
echo Git hash: $GIT_REF

## build docker image
IMAGE_NAME_AND_TAG=cosmart/cosmart-ors-service:${GIT_REF}
echo New image name: $IMAGE_NAME_AND_TAG

docker build --build-arg ENV_ARG=$BUILD_ENV . -t $IMAGE_NAME_AND_TAG

## push image to AWS

aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 607133656658.dkr.ecr.ap-southeast-1.amazonaws.com
docker tag $IMAGE_NAME_AND_TAG 607133656658.dkr.ecr.ap-southeast-1.amazonaws.com/cosmart-ors-service:latest
docker push 607133656658.dkr.ecr.ap-southeast-1.amazonaws.com/cosmart-ors-service:latest
