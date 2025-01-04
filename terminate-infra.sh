# Terminate the CloudFormation template and static resources

echo -e "\n\n=========== Terminate main.yml ==========="
aws cloudformation delete-stack --stack-name awsbootstrap --region ap-south-1

echo -e "\n\n=========== Terminate setup.yml ==========="
aws cloudformation delete-stack --stack-name awsbootstrap-stack --region ap-south-1