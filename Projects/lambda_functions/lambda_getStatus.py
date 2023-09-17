import boto3
import json

def handler(event, context):
    try:
        ec2 = boto3.client('ec2', region_name="${REGION_NAME}")
        instance_status = client.describe_instance_status(InstanceIds=["${INSTANCE_ID}"], IncludeAllInstances=True)['InstanceStatuses'][0]['InstanceState']['Name']
        return {
            'statusCode': 200,
            'body': json.dumps(instance_status)
		}
    except:
        return {
            'statusCode': 200,
            'body': json.dumps('FAILURE')
        }