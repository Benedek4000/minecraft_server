#!/bin/bash
set -e
aws s3 sync $S3_SOURCE $S3_TARGET --delete
