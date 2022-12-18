# Auto deploy k8s cluster

# 필독

본 문서는 terraform과 ansible을 사용하여 AWS 상에 쿠버네티스 클러스터를 구축하는 실습을 다루고 있습니다. 따라서 약간의 비용이 발생할 수 있으며, 실습 후에는 리소스를 안전하게 삭제하시길 바랍니다. 

# Access Key 생성

Terraform으로 AWS 리소스들을 생성할 수 있도록 루트 사용자 액세스 키를 생성합니다. 

1. AWS console에 접속하여 우측 상단의 계정 이름 ⇒ 보안 자격 증명 클릭
    
    ![Untitled](https://user-images.githubusercontent.com/38430523/208302535-8486dd32-8607-4fdf-aa6f-438cfa0a2c40.png)
    
2. [액세스 키 만들기] 클릭
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e83ac673-e008-47b1-a6b7-811a036d3cf8/Untitled.png)
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/911fd8da-9798-4497-89b4-41aa6447e867/Untitled.png)
    
3. [.csv 파일 다운로드] 클릭 하여, 액세스 키와 비밀 액세스 키 확인
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3595759f-af6a-4bd8-9e10-7e15f8d31db3/Untitled.png)
    

# 실습 준비

- ubuntu 20.04 가상머신 사용
- 원활한 실습을 위해 root 유저로 진행
    
    ```
    $ sudo su
    $ cd
    (현재 위치는 /root여야 함)
    ```
    
- 키 페어 준비 (root 계정으로 실행)
    
    ```
    $ ssh-keygen -q -f /root/.ssh/id_rsa -N ""
    ```
    

# Terraform 및 기타 패키지 설치

```
$ sudo apt update
$ sudo apt-get install -y awscli curl vim
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com	$(lsb_release	-cs) main"
$ sudo apt update
$ sudo apt-get -y install terraform
$ terraform	-v (terraform version 확인)
```

# AWS Configure

```
$ aws configure
AWS Access Key ID [None] : (csv 파일 확인하여 Access Key 입력)
AWS Secret Access Key [None] : (csv 파일 확인하여 Secret Access Key 입력)
Default region name [None] : ap-northeast-1 (region 지정. 본인은 도쿄 선택)
Default Output format [None] : (그냥 Enter)
```

# 실습 파일 다운로드 및 실행

1. 깃허브에서 파일 clone
    
    https://github.com/minnnmin/auto_deploy_k8s_cluster
    
    ```
    $ git clone https://github.com/minnnmin/auto_deploy_k8s_cluster.git
    ```
    
    ```
    $ ls
    auto_deploy_k8s_cluster  snap
    ```
    
2. 프로젝트 폴더인 auto_deploy_k8s_cluster로 이동해서 main.tf 수정
    
    ```
    $ cd auto_deploy_k8s_cluster/
    $ vi main.tf 
    (main.tf 파일 최하단에 이전에 생성해 놓은 퍼블릭 키 입력)
    
    # 퍼블릭 키 확인 명령어
    $ cat /root/.ssh/id_rsa.pub
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvg3zbQmJG4uitM2kdnLwYQ5+2YwT8/wBqAoQEh2qU7IUfEfOtSTDPrCqehWvjZsYD2tGYFzkd/LMAoQDd8vBTS3FRtOw6LAUf24CO7USGin0R5aq/rq+tJQDdIRm658Y2z72UoAgQZXBz1ZGO6TFckx57VFN1Krj2qetO5uzE1xiufYax7ttFpmDePpUfBcjCw1wMUIZmotVM5AGT45rCWrmI7dTEls+xYEx5hJzdDymw6EcaZ9WoQoYf+ncBnedaAqCR+suhMdaS5nXUAUitSpvf8AB85zfUuF1O2T5twRUNZxPJXR2msKN6ChGGvPJ9wNV4RvUDIBJ0YKCMPUYvXNM1fRkL+reDZi1dxLNsRRgqhxj/wO+og+r6tk3pbKHYJtHuNCuw3IjavZinAu7i4LbeM35eJZMFlMpqJFP4MBp60Nt8Z5I/5pDqfH3hnbzYsJkG8EuKsrqdJ8HF/NQiKm/eCV0c8kz3Agm5jZZF+1rMKW7wi6Tnv7D2S6f4+l0= root@ubuntu
    ```
    
    퍼블릭 키 내용을 아래처럼 그대로 복사합니다. 
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b38037bc-f64b-4dbe-94bb-7d583b30bbef/Untitled.png)
    

1. 프로젝트 폴더 안의 boot로 이동하여 스크립트 실행
    
    ```
    
    $ cd boot/
    $ sh boot.sh
    ```
    

1. 대략 10-15분 뒤, 클러스터 구축 완료
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8b597b8b-63c6-4025-9ade-2aa6015fc56f/Untitled.png)
    
2. 커맨드 창의 안내대로 테스트
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5ea074ee-9970-44b2-86ec-93c7b773ac25/Untitled.png)
    
    ```
    # master node ssh 접속
    $ ssh -i /root/.ssh/id_rsa 54.199.54.23
    
    # k8s cluster 노드들 상태 확인
    ```
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ae50252c-8a00-48bb-9d95-25710efa11b1/Untitled.png)
    
    ```
    $ cd k8s/
    $ kubectl create cm cm1 --from-file=index.html
    $ kubectl apply -f nginx-deploy.yaml
    ```
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7fe8e687-c74a-42fc-98fa-d797828c0440/Untitled.png)
    
    이후 AWS console 접속하여 로드밸런서 주소 확인
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2af20e92-7b4a-4d84-bb7d-bf2429880f3a/Untitled.png)
    
    브라우저에 해당 주소 입
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3d326907-1c1b-47d3-b547-4196acab630c/Untitled.png)
    

<aside>
💡 테스트를 통해 쿠버네티스 클러스터가 정상적으로 작동하는지 확인했다면, 쿠버네티스 클러스터를 마음껏 사용하시면 됩니다 :)

</aside>

각 파일에 대한 설명은 아래를 참고하세요

[Auto_deploy_k8s_cluster_on_AWS_파일_설명.pdf](https://drive.google.com/file/d/17b8qeh2chW3_GpJVp1N8NBIM1-7FI40y/view?usp=drivesdk)

# 종료

AWS console에서 리소스를 하나하나 지워도 되지만, 실수로 지우지 못한 리소스가 있을 경우 예상치 못한 과금이 발생할 수 있습니다. 따라서 terraform 명령어를 통해 깔끔하게 리소스들을 삭제합니다. 

1. 프로젝트 폴더(auto_deploy_k8s_cluster) 위치에서 아래 명령 실행
