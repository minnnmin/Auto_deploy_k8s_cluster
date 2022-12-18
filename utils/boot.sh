#!/bin/bash

echo "====================== [running utils/boot.sh] ====================="
sh 1st.sh

sudo chmod o+w /etc/ansible/hosts
sh 2nd.sh

sudo chmod o+w /etc/ssh/ssh_config
sh 3rd.sh

sh 4th.sh