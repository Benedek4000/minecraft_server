import boto3
import json

def handler(event, context):
    try:
        client = boto3.client('ec2', region_name="${REGION_NAME}")
        instance_status = client.describe_instance_status(InstanceIds=["${INSTANCE_ID}"])
        codes = {
            '0': 'pending',
            '16': 'running',
            '32': 'shutting down',
            '48': 'terminated',
            '64': 'stopping',
            '80': 'stopped'
		}
        instance_status_code = instance_status['InstanceStatuses'][0]['InstanceState']['Code']
        server_status = codes[str(instance_status_code)]
        return {
            'statusCode': 200,
            'body': json.dumps(server_status)
		}
    except:
        return {
            'statusCode': 500,
            'body': json.dumps('FAILURE')
        }