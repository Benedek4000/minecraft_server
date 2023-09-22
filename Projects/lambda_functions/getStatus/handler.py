import boto3
import json
import os


def handler(event, context):
    try:
        instance_id = os.environ['INSTANCE_ID']
        region = os.environ['REGION']

        ec2 = boto3.client('ec2', region_name=region)
        instance_status = ec2.describe_instance_status(InstanceIds=[instance_id], IncludeAllInstances=True)[
            'InstanceStatuses'][0]['InstanceState']['Name']
        return {
            'statusCode': 200,
            'body': json.dumps(instance_status)
        }
    except:
        return {
            'statusCode': 200,
            'body': json.dumps('FAILURE')
        }
