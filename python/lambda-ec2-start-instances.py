import boto3
import time

ec2 = boto3.resource('ec2', region_name='us-east-1')
region = 'us-east-1'

def lambda_handler(event, context):

    filters = [{
            'Name': 'tag:start',
            'Values': ['0700']
        },
        {
            'Name': 'instance-state-name', 
            'Values': ['stopped']
        }
    ]
    
    instances = ec2.instances.filter(Filters=filters)

    RunningInstances = [instance.id for instance in instances]
  
    if len(RunningInstances) > 0:
        starting = ec2.instances.filter(InstanceIds=RunningInstances).start()
        print('Starting: ' + str(RunningInstances))
    else:
        print("No Instances stopped")