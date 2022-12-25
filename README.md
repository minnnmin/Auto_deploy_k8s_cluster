# 들어가는 글

본 문서는 terraform과 ansible을 사용하여 AWS 상에 쿠버네티스 클러스터를 구축하는 실습을 다루고 있습니다. </br>
따라서 약간의 비용이 발생할 수 있으며, 실습 후에는 리소스를 안전하게 삭제하시길 바랍니다. 


# Access Key 생성

Terraform으로 AWS 리소스들을 생성할 수 있도록 AWS 사용자 정보를 지정해주어야 합니다. </br>

실습에서는 편의를 위해 루트 사용자 액세스 키를 사용할 것이며, </br>
별도의 IAM 사용자로 진행하려면 `AmazonEC2FullAccess`, `AmazonVPCFullAccess` 두 가지의 정책을 부여하면 됩니다.

1. AWS console에 접속하여 우측 상단의 계정 이름 ⇒ [보안 자격 증명] 클릭
    
    ![Untitled](https://user-images.githubusercontent.com/38430523/208302535-8486dd32-8607-4fdf-aa6f-438cfa0a2c40.png)
    
2. [액세스 키 만들기] 클릭
    
    ![Untitled (1)](https://user-images.githubusercontent.com/38430523/208302537-877cbed2-6a89-49bd-9639-f2aca50dc23f.png)
    
    ![Untitled (2)](https://user-images.githubusercontent.com/38430523/208302544-8a9cf500-6fc2-4a18-a358-3bf7fa60d02d.png)
    
3. [.csv 파일 다운로드] 클릭 하여, 액세스 키와 비밀 액세스 키 확인
    
    ![Untitled (3)](https://user-images.githubusercontent.com/38430523/208302556-dacf7240-8ba7-4782-bcd3-581d9314dc02.png)
    

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
    
    ![Untitled (4)](https://user-images.githubusercontent.com/38430523/208302696-bd3e850e-8154-47c1-b21d-30776e4bd4a4.png)
    
3. 프로젝트 폴더 안의 boot로 이동하여 스크립트 실행
    
    ```
    $ cd boot/
    $ sh boot.sh
    ```

4. 대략 10-15분 뒤, 클러스터 구축 완료
    
    ![Untitled (5)](https://user-images.githubusercontent.com/38430523/208302699-4bbd19b7-e83e-42c8-b831-4e5378049737.png)

5. 커맨드 창의 안내대로 테스트
    
    <img width="960" alt="Untitled (6)" src="https://user-images.githubusercontent.com/38430523/208302702-6e4e8628-fc00-4d6a-abb9-3673d62fe8f6.png">
    
    ```
    # master node ssh 접속
    $ ssh -i /root/.ssh/id_rsa 54.199.54.23
    
    # k8s cluster 노드들 상태 확인
    ```
    
    ![Untitled (7)](https://user-images.githubusercontent.com/38430523/208302705-32d67cae-27d4-43cb-a7a1-bd266d5d8766.png)
    
    ```
    $ cd k8s/
    $ kubectl create cm cm1 --from-file=index.html
    $ kubectl apply -f nginx-deploy.yaml
    ```
    
    ![Untitled (8)](https://user-images.githubusercontent.com/38430523/208302712-5bde5f3b-fefb-47d0-84f7-7545ea225752.png)
    
    이후 AWS console 접속하여 로드밸런서 주소 확인
    
    <img width="960" alt="Untitled (9)" src="https://user-images.githubusercontent.com/38430523/208302716-1ad9ec41-f5ee-464a-b4be-3cd3ed02edf2.png">
    
    브라우저에 해당 주소 입력
    
    ![Untitled (10)](https://user-images.githubusercontent.com/38430523/208302719-57eceed6-3446-4055-b143-76351091b4eb.png)
    
    

💡 테스트를 통해 쿠버네티스 클러스터가 정상적으로 작동하는지 확인했다면, 쿠버네티스 클러스터를 마음껏 사용하시면 됩니다 :)

💡 각 파일에 대한 설명은 아래를 참고하세요
    [Auto_deploy_k8s_cluster_on_AWS_파일_설명.pdf](https://drive.google.com/file/d/17b8qeh2chW3_GpJVp1N8NBIM1-7FI40y/view?usp=drivesdk)


# 종료

AWS console에서 리소스를 하나하나 지워도 되지만, 실수로 지우지 못한 리소스가 있을 경우 예상치 못한 과금이 발생할 수 있습니다. 따라서 terraform 명령어를 통해 깔끔하게 리소스들을 삭제합니다. 

1. 프로젝트 폴더(auto_deploy_k8s_cluster) 위치에서 아래 명령 실행
    
    ```
    $ terraform destroy -auto-approve
    ```
