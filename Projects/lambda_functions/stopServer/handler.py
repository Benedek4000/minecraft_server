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
        if instance_status == "stopped":
            return {
                'statusCode': 200,
                'body': json.dumps('Server is currently stopped.')
            }
        else:
            ssm = boto3.client('ssm', region_name=region)
            responses = ssm.send_command(DocumentName="AWS-RunShellScript", Parameters={
                                         'commands': ['sudo bash /home/ubuntu/stop_service.sh']}, InstanceIds=[instance_id])
            return {
                'statusCode': 200,
                'body': json.dumps('Server stops in 5 minutes. It may take up to 2 further minutes for the server to shut down.')
            }
    except:
        return {
            'statusCode': 200,
            'body': json.dumps('FAILURE')
        }
