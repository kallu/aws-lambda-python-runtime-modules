#!/bin/bash

STACK_NAME=python-runtime-dump
TEMPLATE=template.yaml

aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://${TEMPLATE} \
  --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM CAPABILITY_NAMED_IAM || true

aws cloudformation wait stack-create-complete \
  --stack-name ${STACK_NAME}

FUNCTION_URL=$(aws cloudformation describe-stacks \
  --stack-name ${STACK_NAME} \
  --query 'Stacks[0].Outputs[]' | jq -r '.[] | select(.OutputKey=="FunctionUrl").OutputValue')

echo ${FUNCTION_URL}

