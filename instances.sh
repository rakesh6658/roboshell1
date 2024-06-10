imageid=ami-0f3c7d07486cad139
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
private_ip=$( aws ec2 run-instances  --image-id $imageid  --instance-type $instance_type  --security-group-ids $security_groupid --subnet-id $subnetid | jq -r '.Instances[0].PrivateIpAddress')

done
# aws route53 change-resource-record-sets --hosted-zone-id Z07861153FFB7P0M0D6G8 --change-batch 
#"mysql" "rabbitmq" "shipping" "dispatch" "payment"
# {
#     "Comment": "Update record to add new CNAME record",
#     "Changes": 
#     [
#         {
#             "Action": "CREATE",
#             "ResourceRecordSet": {
#                 "Name": "${modules[@]}.rakeshreddy.online",
#                 "Type": "A",
#                 "TTL": "300",
#                 "ResourceRecords": [
#                     {
#                         "Value": "$private_ip"
#                     }
#                 ]
#             }
#         }
#     ]
# }
# done