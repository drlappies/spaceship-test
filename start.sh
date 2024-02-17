#!/bin/bash

docker-compose -f ./spaceship-test-service/docker-compose.yml up -d

yarn --cwd ./spaceship-test-service install

yarn --cwd ./spaceship-test-web install

yarn install

npx concurrently "yarn --cwd ./spaceship-test-service start:dev" "PORT=8000 yarn --cwd ./spaceship-test-web start"
