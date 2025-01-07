# Terminate the CloudFormation template and static resources

echo "\n\n=========== Terminate main.yml ==========="
aws cloudformation delete-stack --stack-name awsbootstrap --region ap-south-1

echo  "\n\n=========== Terminate setup.yml ==========="
aws cloudformation delete-stack --stack-name awsbootstrap-setup --region ap-south-1

echo "\n\n=========== Force delete the s3 buckets ==========="
aws s3 rb s3://awsbootstrap-ap-south-1-codepipeline-225989374887 --force