imageid=ami-0f3c7d07486cad139
instance_type=t2.micro
security_groupid=sg-05767c7a9b8ae16b0
subnetid=subnet-036554fe159737dc4

modules=("mongodb" "redis" "catalogue" "cart" "user" "mysql" "rabbitmq" "shipping" "dispatch" "payment")
for i in $modules
do
if [ i == "mongodb" || i == "mysql"]
then
$instance_type=t3.micro
private_ip=$( aws ec2 run-instances  --image-id $imageid  --instance-type $instance_type  --security-group-ids $security_groupid --subnet-id $subnetid | jq -r '.Instances[0].PrivateIpAddress')
else
private_ip=$( aws ec2 run-instances  --image-id $imageid  --instance-type $instance_type  --security-group-ids $security_groupid --subnet-id $subnetid | jq -r '.Instances[0].PrivateIpAddress')
fi
aws route53 change-resource-record-sets --hosted-zone-id Z07861153FFB7P0M0D6G8 --change-batch 
{
    "Comment": "Update record to add new CNAME record",
    "Changes": 
    [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "$modules.rakeshreddy.online",
                "Type": "A",
                "TTL": 300,
                "ResourceRecords": [
                    {
                        "Value": "$modules"
                    }
                ]
            }
        }
    ]
}

done