#!/bin/bash
while :; do ps aux | grep -v grep | grep make; sleep 0.01 ; done