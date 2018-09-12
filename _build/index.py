import json
import os

# pipenv install <module> 
# pipenv run pip install -r <(pipenv lock -r) --target _build/
import requests




def lambda_handler(event, context):
    """Sample pure Lambda function

    Arguments:
        event LambdaEvent -- Lambda Event received from Invoke API
        context LambdaContext -- Lambda Context runtime methods and attributes

    Returns:
        dict -- {'statusCode': int, 'body': dict}
    """

    ip = requests.get('http://checkip.amazonaws.com/')


    print("event: {}".format(event))
    print("event body: {}".format(event.get("body")))
    print("Dynamo env name: {}".format(os.environ.get("DynamoTableName")))

    body = {}
    if event.get("httpMethod","").upper() in ["POST", "PUT"]:
        print("POST/PUT, getting body")
        body = json.loads(event.get("body",'{}'))
    
    num = body.get("number",0)
    ret = num**2
    
    modelId = event.get("pathParameters",{}).get("modelId", "Unknown")

    ## Record IP address associated with a modelID


    return {
        "statusCode": 200,
        "body": json.dumps({
            'message': 'hello world',
            'location': ip.text.replace('\n', ''),
            'squared': ret,
            "modelId": modelId})
    }
