import boto3
import json
import time

def handler(event, context):
    try:
        ec2 = boto3.client('ec2', region_name="${REGION_NAME}")
        responses = ec2.start_instances(InstanceIds=["${INSTANCE_ID}"])
        time.sleep(5)
        responses = ec2.describe_instances(InstanceIds=["${INSTANCE_ID}"])
        ip = responses["Reservations"][0]["Instances"][0]["PublicIpAddress"]
        route53 = boto3.client('route53')
        responses = route53.change_resource_record_sets(HostedZoneId="${ZONE_ID}", ChangeBatch={
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "${NAME_TAG}",
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
