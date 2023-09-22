import boto3
import json
import time
import os


def handler(event, context):
    try:
        instance_id = os.environ['INSTANCE_ID']
        region = os.environ['REGION']
        zone_id = os.environ['ZONE_ID']
        name_tag = os.environ['NAME_TAG']

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
        return {
            'statusCode': 200,
            'body': json.dumps('Server started. It may take up to 2 minutes for the server to start up.')
        }
    except:
        return {
            'statusCode': 200,
            'body': json.dumps('FAILURE')
        }
