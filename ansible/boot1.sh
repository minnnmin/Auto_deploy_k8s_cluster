#!/bin/bash

echo ""
echo ""
echo "==================== [running ansible/boot1.sh] ===================="
ansible-playbook k8s_containrd_pkg.yml > /dev/null 2>&1