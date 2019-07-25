#!/bin/bash
echo curl -X POST https://$1/api-token-auth \
	 -H 'Accept: application/json, text/plain, */*' \
	 -H 'Content-Type: application/json' \
	 -H 'Postman-Token: ba3e45e2-dfd7-4a-cedc0964b23e' \
	 -H 'cache-control: no-cache' \
	 -d '{ "username": '$2', "password": '$3' }'