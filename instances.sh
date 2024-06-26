imageid=ami-0b4f379183e5706b9
instance_type=""
security_groupid=sg-0ba387cf504f1383b
DOMAIN_NAME=rakeshreddy.online
HOSTED_ZONE_ID=Z01861853FDUCS1FFDRY1
for i in $@
do
if ((i=="mongodb" || i=="mysql"))
then
instance_type=t3.micro
else
instance_type=t2.micro
fi
echo "creating instance $i"
private_ip=$( aws ec2 run-instances  --image-id $imageid  --instance-type $instance_type  --security-group-ids $security_groupid --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$private_ip'"}]
                        }}]
    }
    '
done