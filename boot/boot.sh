#!/bin/bash

echo "===================== [running terraform init] ====================="
sleep 1
cd .. ; terraform init > /dev/null 2>&1

echo "===================== [running terraform plan] ====================="
sleep 1
terraform plan > /dev/null 2>&1

echo "===================== [running terraform apply] ===================="
sleep 1
terraform apply -auto-approve > /dev/null 2>&1
sleep 30

echo "===================== [start configuring VMs] ======================"
cd boot ; sh configure_infra.sh