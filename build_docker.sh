#!/bin/bash
docker build --rm --force-rm -t hysds/dev:latest -f docker/Dockerfile .
