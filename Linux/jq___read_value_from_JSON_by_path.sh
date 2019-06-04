#!/bin/bash
echo {\"body\": {\"key\": \"value\"}} | jq -r ".body.key"