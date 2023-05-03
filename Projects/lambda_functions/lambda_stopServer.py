import boto3
import json

def handler(event, context):
    try:
        client = boto3.client('ec2', region_name="${REGION_NAME}")
        instance_status = client.describe_instance_status(InstanceIds=["${INSTANCE_ID}"], IncludeAllInstances=True)['InstanceStatuses'][0]['InstanceState']['Name']
        if instance_status == "stopped":
            return {
                'statusCode': 200,
                'body': json.dumps('Server is currently stopped.')
            } 
        else:
            client = boto3.client('ssm',region_name="${REGION_NAME}")
            responses = client.send_command(DocumentName="AWS-RunShellScript", Parameters={'commands': ['sudo bash /home/ubuntu/stop_service.sh']}, InstanceIds=["${INSTANCE_ID}"])
            return {
                'statusCode': 200,
                'body': json.dumps('Server stops in 5 minutes. It may take up to 2 further minutes for the server to shut down.')
            }
    except:
        return {
            'statusCode': 200,
            'body': json.dumps('FAILURE')
        }
