#!/bin/bash
# possible alternatives
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

# configure alternative (choose alternative)
sudo update-alternatives --config python3

# test configuration
python3 -V