import boto3
import time

ec2 = boto3.resource('ec2', region_name='sa-east-1')
region = 'sa-east-1'

def lambda_handler(event, context):

    filters = [{
            'Name': 'tag:shutdown',
            'Values': ['1900']
        },
        {
            'Name': 'instance-state-name', 
            'Values': ['running']
        }
    ]
    
    instances = ec2.instances.filter(Filters=filters)

    RunningInstances = [instance.id for instance in instances]
  
    if len(RunningInstances) > 0:
        shuttingDown = ec2.instances.filter(InstanceIds=RunningInstances).stop()
        print('shuttingDown: ' + str(RunningInstances))
    else:
        print("No Instances running")