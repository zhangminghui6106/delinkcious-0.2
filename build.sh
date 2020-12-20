#!/bin/bash

set -eo pipefail

IMAGE_PREFIX='g1g1'
STABLE_TAG='0.2'

TAG="${STABLE_TAG}.${CIRCLE_BUILD_NUM}"
ROOT_DIR="$(pwd)"
echo "pwd:$(pwd)"
SVC_DIR="${ROOT_DIR}/svc"
cd $SVC_DIR
docker login -u itinfomation -p Zmh920226docker!
for svc in *; do
    cd "${SVC_DIR}/$svc"
    if [[ ! -f Dockerfile ]]; then
        continue
    fi
    UNTAGGED_IMAGE=$(echo "${IMAGE_PREFIX}/delinkcious-${svc}" | sed -e 's/_/-/g' -e 's/-service//g')
    STABLE_IMAGE="${UNTAGGED_IMAGE}:${STABLE_TAG}"
    IMAGE="${UNTAGGED_IMAGE}:${TAG}"
    echo "svc:$svc"
    echo "image: $IMAGE"
    echo "stable image: ${STABLE_IMAGE}"
    cat /etc/issue
    whoami
    echo "sudo systemctl status docker"
    docker version
    echo "sudo systemctl start docker"
    echo "docker started"
    echo $IMAGE
    docker build -t "$IMAGE" .
    sudo docker tag "${IMAGE}" "${STABLE_IMAGE}"
    sudo docker push "${IMAGE}"
    sudo docker push "${STABLE_IMAGE}"
done
cd $ROOT_DIR