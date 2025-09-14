#!/bin/bash

RUNTIMES=./runtimes
STACK_NAME=python-runtime-dump
TEMPLATE=template.yaml

#aws cloudformation create-stack \
#  --stack-name ${STACK_NAME} \
#  --template-body file://${TEMPLATE} \
#  --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM CAPABILITY_NAMED_IAM || true

#aws cloudformation wait stack-create-complete \
#  --stack-name ${STACK_NAME}

#FUNCTION_URL=$(aws cloudformation describe-stacks \
#  --stack-name ${STACK_NAME} \
#  --query 'Stacks[0].Outputs[]' | jq -r '.[] | select(.OutputKey=="FunctionUrl").OutputValue')

for R in $(cat runtimes)
do
  aws cloudformation deploy \
    --stack-name ${STACK_NAME} \
    --template-file ${TEMPLATE} \
    --parameter-overrides PythonRuntime=${R} \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset

  sleep 5

  aws cloudformation wait stack-update-complete \
    --stack-name ${STACK_NAME}

  FUNCTION_URL=$(aws cloudformation describe-stacks \
    --stack-name ${STACK_NAME} \
    --query 'Stacks[0].Outputs[]' | jq -r '.[] | select(.OutputKey=="FunctionUrl").OutputValue')

  curl ${FUNCTION_URL} -o ${R}-requirements.txt
done

aws cloudformation delete-stack \
  --stack-name ${STACK_NAME}
