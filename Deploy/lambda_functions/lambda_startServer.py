import boto3

def handler(event, context):
    client = boto3.client('ec2',region_name="${REGION_NAME}")
    responses = client.start_instances(InstanceIds=["${INSTANCE_ID}"])
    print(responses)

# add even scheduler