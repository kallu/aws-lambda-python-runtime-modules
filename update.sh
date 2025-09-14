#!/bin/bash

RUNTIMES=./runtimes
STACK_NAME=python-runtime-dump
TEMPLATE=template.yaml

for R in $(cat runtimes)
do
  aws cloudformation deploy \
    --stack-name ${STACK_NAME} \
    --template-file ${TEMPLATE} \
    --parameter-overrides PythonRuntime=${R} \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset

  aws cloudformation wait stack-exists\
    --stack-name ${STACK_NAME}

  # Wait until stack is created or updated

  while true
  do
    STACK_STATUS=$(aws cloudformation describe-stacks \
      --stack-name ${STACK_NAME} \
      --query 'Stacks[0].StackStatus' \
      --output text)
    echo "Stack status $(STACK_STATUS)"
    [[ "$(STACK_STATUS)" == *_COMPLETE ]] && break
    sleep 5
  done

  FUNCTION_URL=$(aws cloudformation describe-stacks \
    --stack-name ${STACK_NAME} \
    --query 'Stacks[0].Outputs[]' | jq -r '.[] | select(.OutputKey=="FunctionUrl").OutputValue')

  curl ${FUNCTION_URL} -o ${R}-requirements.txt
done

aws cloudformation delete-stack \
  --stack-name ${STACK_NAME}
