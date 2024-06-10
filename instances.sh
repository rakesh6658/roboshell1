imageid=ami-0b4f379183e5706b9
instance_type=""
security_groupid=sg-0ba387cf504f1383b
for i in $@
do
if ((i=="mongodb" || i=="mysql"))
then
instance_type=t3.micro
else
instance_type=t2.micro
fi
echo "creating instance $i"
private_ip=$( aws ec2 run-instances  --image-id $imageid  --instance-type $instance_type  --security-group-ids $security_groupid  | jq -r '.Instances[0].PrivateIpAddress')


aws route53 change-resource-record-sets --hosted-zone-id Z01861853FDUCS1FFDRY1 --change-batch
{
    [
        {
            "Action": "CREATE",
            "ResourceRecordSet": {
                "Name": "$i.rakeshreddy.online",
                "Type": "A",
                "TTL": "300",
                "ResourceRecords": [
                    {
                       "Key": "$i", "Value": "$private_ip"
                    }
                ]
            }
        }
    ]
}
done