#!/bin/bash
find . -name '*.tf' -printf "%h\n" | uniq | xargs -n1 terraform12 fmt