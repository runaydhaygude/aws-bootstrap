#!/bin/bash

GH_ACCESS_TOKEN=$(cat ~/.github/aws-bootstrap-access-token)
GH_OWNER=$(cat ~/.github/aws-bootstrap-owner)
GH_REPO=$(cat ~/.github/aws-bootstrap-repo)
GH_BRANCH=master

STACK_NAME=awsbootstrap 
REGION=ap-south-1 
CLI_PROFILE=personal

EC2_INSTANCE_TYPE=t2.micro

echo -e "EC2_INSTANCE_TYPE: $EC2_INSTANCE_TYPE" 

AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
 
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

echo "CODEPIPELINE_BUCKET=$CODEPIPELINE_BUCKET"


# Deploys static resources
echo -e "\n\n=========== Deploying setup.yml ==========="

aws cloudformation deploy \
    --region $REGION \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME-setup \
    --template-file setup.yml \
    --no-fail-on-empty-changeset \
    --parameter-overrides CodePipelineBucket=$CODEPIPELINE_BUCKET


# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides EC2InstanceType=$EC2_INSTANCE_TYPE GitHubOwner=$GH_OWNER \
    GitHubRepo=$GH_REPO \
    GitHubBranch=$GH_BRANCH \
    GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
    CodePipelineBucket=$CODEPIPELINE_BUCKET


    # If the deploy succeeded, show the DNS name of the created instance
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?Name=='InstanceEndpoint'].Value" 
fi