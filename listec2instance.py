import boto3
from prettytable import PrettyTable
ec2 = boto3.resource('ec2')
for instance in ec2.instances.all():

    if (instance.instance_type=="m5.large"):

        y=instance.id
        x=instance.tags[0]['Value']
        t = PrettyTable(['Name Tag', 'Instance ID'])
        t.add_row([x, y])
        print(t)

    else:

        print ("Instance not found")

