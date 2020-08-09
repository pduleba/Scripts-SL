#!/bin/bash
# Sample execution: /bin/openvpn_st.sh eu

base_path=/home/pduleba/workspace/documents/ovpn
vpn_us=prod-us.client-vpn.mgmt-prod.main.us.ovpn
vpn_eu=prod-eu.client-vpn.mgmt-prod.main.us.ovpn

case "$1" in
   "eu")
      vpn_conf=$vpn_eu ;;
   "us")
      vpn_conf=$vpn_us ;;
   *)
      echo "Unsupported vpn conf '$1'"
      exit 1 ;;
esac

sudo openvpn --config "${base_path}/${vpn_conf}" --auth-user-pass --auth-retry interact
