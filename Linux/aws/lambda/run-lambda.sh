#!/usr/bin/env bash
aws lambda invoke --region=eu-west-1 --function-name=exp-poc-rm2-pduleba-rm-transaction-lambda-lambda --payload file://input.txt output.txt
