#!/bin/bash
# current user
id

# specific user
id root
# uid=0(root) gid=0(wheel) groups=0(wheel) ....


# for list of users see
ls /var/db/dslocal/nodes/Default/users
ls /var/db/dslocal/nodes/Default/users | grep -vE '^_'
# or run
dscl . list /Users | grep -v '^_'