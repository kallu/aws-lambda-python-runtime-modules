#!/bin/bash

RUNTIMES=./runtimes
STACK_NAME=python-runtime-dump
TEMPLATE=template.yaml

for R in $(cat runtimes)
do
  echo "Lambda runtime ${R} ..."
  aws cloudformation deploy \
    --stack-name ${STACK_NAME} \
    --template-file ${TEMPLATE} \
    --parameter-overrides PythonRuntime=${R} \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset

  FUNCTION_URL=$(aws cloudformation describe-stacks \
    --stack-name ${STACK_NAME} \
    --query 'Stacks[0].Outputs[]' | jq -r '.[] | select(.OutputKey=="FunctionUrl").OutputValue')

  curl --no-progress-meter -o ${R}-requirements.txt ${FUNCTION_URL}
done

aws cloudformation delete-stack \
  --stack-name ${STACK_NAME}
