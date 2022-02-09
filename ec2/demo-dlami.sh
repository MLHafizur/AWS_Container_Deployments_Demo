export REGION=eu-west-1
export AMI_ID=ami-0d1719cfc8e2f69b4    # Deep Learning AMI (Amazon Linux 2) in eu-west-1
export SECURITY_GROUP_ID=sg-0262e9c0dad040106
export ROLE_NAME=AdminRole
export KEY_NAME=admin
export KEY_PAIR=~/.ssh/admin.pem

aws configure set region $REGION

# Create a p3.2xlarge spot instance
aws ec2 run-instances --image-id $AMI_ID \
                       --instance-type p3.2xlarge \
                       --instance-market-options '{"MarketType":"spot"}' \
                       --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=dlami-demo}]' \
                       --key-name $KEY_NAME \
                       --security-group-ids $SECURITY_GROUP_ID \
                       --iam-instance-profile Name=$ROLE_NAME

# Get the public DNS name
export INSTANCE_NAME=`aws ec2 describe-instances --filters "Name=tag:Name,Values=dlami-demo" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].PublicDnsName" --output text`

echo $INSTANCE_NAME

*** Local

# ssh to the instance, redirecting local port 8000 to the Jupyter port
ssh -i $KEY_PAIR -L 8000:localhost:8888 ec2-user@$INSTANCE_NAME

*** EC2

jupyter notebook --no-browser --port=8888

*** Local

open http://localhost:8000

# Get the instance id
export INSTANCE_ID=`aws ec2 describe-instances --filters "Name=tag:Name,Values=dlami-demo" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text`

echo $INSTANCE_ID

# Terminate the instance
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
