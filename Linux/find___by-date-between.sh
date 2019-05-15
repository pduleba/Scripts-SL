#!/bin/bash
find . -mmin -$[$[$(date +%s)-$(date -d "2015-03-04 00:00:00" +%s)]/60] -mmin +$[$[$(date +%s)-$(date -d "2015-03-06 00:00:00" +%s)]/60]