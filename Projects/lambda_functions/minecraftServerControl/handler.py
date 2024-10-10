import os
import json
import boto3
import time

def handler(event, context):
	try:
		instance_id = os.environ['INSTANCE_ID']
		region = os.environ['REGION']
		zone_id = os.environ['ZONE_ID']
		name_tag = os.environ['NAME_TAG']
		message = ''
		match event['path'][1:]:
			case 'start':
				message = start_server(instance_id, region, zone_id, name_tag)
			case 'stop':
				message = stop_server(instance_id, region)
			case 'status':
				message = get_status(instance_id, region)
			case _:
				message = 'Unknown command'
		return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps(message)
        }
	except Exception as e:
		return {
            'statusCode': 200,
            'body': json.dumps(str(e))
        }
	
def start_server(instance_id, region, zone_id, name_tag):
    try:
        ec2 = boto3.client('ec2', region_name=region)
        responses = ec2.start_instances(InstanceIds=[instance_id])
        time.sleep(5)
        responses = ec2.describe_instances(InstanceIds=[instance_id])
        ip = responses["Reservations"][0]["Instances"][0]["PublicIpAddress"]
        route53 = boto3.client('route53')
        responses = route53.change_resource_record_sets(HostedZoneId=zone_id, ChangeBatch={
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": name_tag,
                        "Type": "A",
                        "TTL": 300,
                        "ResourceRecords": [{"Value": ip}]
                    }
                }
            ]
        })
        return 'Server started. It may take up to 5 minutes for the server to start up.'
    except Exception as e:
        return str(e)
	
def stop_server(instance_id, region):
    try:
        if get_status(instance_id, region) == "stopped":
            return 'Server is currently stopped.'
        else:
            ssm = boto3.client('ssm', region_name=region)
            ssm.send_command(DocumentName="AWS-RunShellScript", Parameters={
                                         'commands': ['sudo bash /home/ubuntu/stop_service.sh']}, InstanceIds=[instance_id])
            return 'Server stops in 5 minutes. It may take up to 2 further minutes for the server to shut down.'
    except Exception as e:
        return str(e)
	
def get_status(instance_id, region):
    try:
        ec2 = boto3.client('ec2', region_name=region)
        instance_status = ec2.describe_instance_status(InstanceIds=[instance_id], IncludeAllInstances=True)[
            'InstanceStatuses'][0]['InstanceState']['Name']
        return instance_status
    except Exception as e:
        return str(e)
    