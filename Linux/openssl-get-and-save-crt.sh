#!/bin/bash
openssl s_client -showcerts -connect app.domain.pl:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > app.domain.pl.pem
openssl x509 -outform der -in app.domain.pl.pem -out app.domain.pl.crt
