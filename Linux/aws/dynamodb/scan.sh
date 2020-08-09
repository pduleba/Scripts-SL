#!/usr/bin/env bash

aws dynamodb scan --table-name test-cft-refund-pduleba-Transactions --projection-expression "id, a, b, pan" --profile admin