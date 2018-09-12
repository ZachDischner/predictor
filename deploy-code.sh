
# For dependencies
# export VIRTUALENV='venv_lambda'
# rm -fr $VIRTUALENV

# # Setup fresh virtualenv and install requirements
# virtualenv $VIRTUALENV
# source $VIRTUALENV/bin/activate
# pip install -r requirements-lambda.txt
# deactivate

# export VIRTUALENV='venv_lambda'
# export ZIP_FILE='lambda.zip'
# export PYTHON_VERSION='python3.6'
# # Zip dependencies from virtualenv, and main.py
# cd $VIRTUALENV/lib/$PYTHON_VERSION/site-packages/
# zip -r9 ../../../../$ZIP_FILE *
# cd ../../../../
# zip -g $ZIP_FILE main.py
source config.aws

rm -rf build/lambda/*.zip

zip -rg build/lambda/package.zip src

aws s3 cp build/lambda/package.zip s3://$SRC_S3BUCKET/src