#!/bin/bash
source config.aws
debug="";#"--debug"

# dev:   ./deploy.sh
# prod:  ./deploy.sh prod
STAGE=${1:-dev}
PROJECT=predictor-$STAGE

## Copy source files into the virtual (pipenv)
echo "Copying files from src into _build" # .venv/lib/python3.6..."
export PIPENV_VENV_IN_PROJECT=1
# cp -r src .venv/lib/python3.6/site-packages
# Reinstall pipenv run pip install -r <(pipenv lock -r) --target _build/
cp -r src/* _build

# make a build directory to store artifacts
rm -rf build
mkdir build
echo "Using s3 bucket ${SRC_S3BUCKET} to upload artifacts"
# make the deployment bucket in case it doesn't exist
if aws ${debug} s3 ls "s3://$SRC_S3BUCKET" 2>&1 | grep -q 'NoSuchBucket'; then
    echo "Creating bucket $SRC_S3BUCKET"
    aws ${debug} s3 mb s3://$SRC_S3BUCKET 
elif aws ${debug} s3 ls "s3://$SRC_S3BUCKET" 2>&1 | grep -q 'AccessDenied'; then
    echo "Bucket $SRC_S3BUCKET exists and you do not have access to it. Choose another name"
    exit 1
else
    echo "Bucket ${SRC_S3BUCKET} already exists"
fi

# generate next stage yaml file
echo "Packaging cloudformation..."
aws ${debug} cloudformation package                   \
    --template-file cloudformation/app-template.yaml  \
    --output-template-file build/output.yaml          \
    --s3-bucket $SRC_S3BUCKET                      

# the actual deployment step
echo "Deploying cloudformation..."
aws ${debug} cloudformation deploy            \
    --template-file build/output.yaml         \
    --stack-name $PROJECT                     \
    --capabilities CAPABILITY_IAM             \
    --parameter-overrides Environment=$STAGE
