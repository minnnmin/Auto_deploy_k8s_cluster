#!/bin/bash

echo ""
echo "==================== [running ansible/boot2.sh] ===================="
ansible-playbook k8s_master_init.yml > /dev/null 2>&1
ansible-playbook k8s_workers.yml > /dev/null 2>&1

echo ""
echo ""
echo ""
echo "======================== all works complete! ======================="
echo "k8s cluster 구성이 끝났습니다"

echo ""
echo ""
echo "============================ [k8s test] ============================"
echo "kubectl get nodes 명령으로 모든 노드가 Ready 상태인지 확인 후"
echo "/home/ubuntu/k8s 로 이동하여, 아래 명령을 차례로 실행하세요"
echo "1) kubectl create cm cm1 --from-file=index.html "
echo "2) kubectl apply -f nginx-deploy.yaml "

echo "배포 후 로드밸런서 주소로 접속하여 확인하세요"