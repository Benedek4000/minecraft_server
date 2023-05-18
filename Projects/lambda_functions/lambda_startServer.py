import boto3
import json

def handler(event, context):
    try:
        client = boto3.client('ec2', region_name="${REGION_NAME}")
        responses = client.start_instances(InstanceIds=["${INSTANCE_ID}"])
        return {
            'statusCode': 200,
            'body': json.dumps('Server started. It may take up to 2 minutes for the server to start up.')
        }
    except:
        return {
            'statusCode': 200,
            'body': json.dumps('FAILURE')
        }
