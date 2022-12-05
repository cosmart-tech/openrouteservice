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
IMAGE_LABEL=cosmart-ors-service-${GIT_REF}
echo New image label: $IMAGE_LABEL

aws lightsail push-container-image --region ap-southeast-1 --service-name ors-service --label $IMAGE_LABEL --image $IMAGE_NAME_AND_TAG
