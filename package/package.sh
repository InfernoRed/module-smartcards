#!/bin/bash

echo "packaging application"

tar --exclude=.git \
    --exclude=.github \
    --exclude=.DS_Store \
    --exclude=.circleci \
    --exclude=.postman \
    --exclude=node_modules \
    --exclude=package \
    --exclude=tests \
    --exclude=.dockerignore \
    --exclude=.gitignore \
    --exclude=Dockerfile \
    --exclude=Makefile \
    -zcvf module-smartcard.tar.gz module-smartcard.service run.sh ../

echo "packaging complete"
