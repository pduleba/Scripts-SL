#!/bin/bash

# Notes:
# * The -W 50 -C 200 flags will create up to 50 x 200 MB capture files and keep rotating at 10 GB to avoid risk of running out of disk space. Values can be adjusted accordingly depending on how much space you are willing to dedicate.
# * The -s 600 flag will truncate the packets to save disk space. 600 bytes captured per packet should give insight into some of the DNS lookup and TLS handshake information.

tcpdump -s 600 -w /tmp/capture.pcap -W 50 -C 200 '(port 443 or port 53 or icmp)'
