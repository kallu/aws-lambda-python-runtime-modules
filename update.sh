#!/bin/bash

STACK_NAME=python-runtime-dump
TEMPLATE=template.yaml

aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://${TEMPLATE} \
  --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM CAPABILITY_NAMED_IAM

aws cloudformation wait stack-create-complete \
  --stack-name ${STACK_NAME}


