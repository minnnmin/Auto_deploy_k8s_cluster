resource "aws_instance" "master" {
  ami = "ami-09b18720cb71042df"
  instance_type = "t2.medium"
  key_name = "aws_key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "master"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sed -i'' -r -e "/master/a${self.private_ip}" utils/private_ips
      echo "ssh-keyscan ${self.private_ip} >> /home/ubuntu/.ssh/known_hosts" >> utils/4th.sh
      echo "chmod 600 ~/.ssh/id_rsa" >> boot/configure_infra.sh
      echo "sudo chmod o+w /etc/ssh/ssh_config" >> boot/configure_infra.sh
      echo "Host    ${self.public_ip}" >> boot/ssh-config-local
      echo "        User ubuntu" >> boot/ssh-config-local
      echo "        Identityfile ~/.ssh/id_rsa" >> boot/ssh-config-local
      echo "cat ssh-config-local >> /etc/ssh/ssh_config" >> boot/configure_infra.sh
      echo "ssh-keyscan ${self.public_ip} >> ~/.ssh/known_hosts" >> boot/configure_infra.sh
      echo "sleep 5" >> boot/configure_infra.sh
      echo "ssh ${self.public_ip} 'cd utils ; sh boot.sh'" >> boot/configure_infra.sh
      echo "ssh ${self.public_ip} 'ansible all -m ping'" >> boot/configure_infra.sh
      echo "ssh ${self.public_ip} 'cd ansible ; sh boot1.sh'" >> boot/configure_infra.sh
      echo "rebooting ..."
      echo "sleep 90" >> boot/configure_infra.sh
      echo "ssh ${self.public_ip} 'cd ansible ; sh boot2.sh'" >> boot/configure_infra.sh
      echo "sleep 20" >> boot/configure_infra.sh
    EOT
  }
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/root/.ssh/id_rsa")
    timeout = "3m"
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir utils",
      "mkdir ansible",
      "mkdir k8s",
    ]
  }
  provisioner "file" {
    source = "/root/.ssh/id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }
  provisioner "file" {
    source = "/root/auto_deploy_k8s_cluster/utils/"
    destination = "/home/ubuntu/utils"
  }
  provisioner "file" {
    source = "/root/auto_deploy_k8s_cluster/ansible/"
    destination = "/home/ubuntu/ansible"
  }
  provisioner "file" {
    source = "/root/auto_deploy_k8s_cluster/k8s/"
    destination = "/home/ubuntu/k8s"
  }

  depends_on = [aws_instance.worker1, aws_instance.worker2, aws_instance.worker3]
}

resource "aws_instance" "worker1" {
  ami = "ami-09b18720cb71042df"
  instance_type = "t2.medium"
  key_name = "aws_key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "worker1"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sed -i'' -r -e "/worker/a${self.private_ip}" utils/private_ips
      echo "ssh-keyscan ${self.private_ip} >> /home/ubuntu/.ssh/known_hosts" >> utils/4th.sh
    EOT
  }
}

resource "aws_instance" "worker2" {
  ami = "ami-09b18720cb71042df"
  instance_type = "t2.medium"
  key_name = "aws_key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "worker2"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sed -i'' -r -e "/worker/a${self.private_ip}" utils/private_ips
      echo "ssh-keyscan ${self.private_ip} >> /home/ubuntu/.ssh/known_hosts" >> utils/4th.sh
    EOT
  }
}

resource "aws_instance" "worker3" {
  ami = "ami-09b18720cb71042df"
  instance_type = "t2.medium"
  key_name = "aws_key"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "worker3"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sed -i'' -r -e "/worker/a${self.private_ip}" utils/private_ips
      echo "ssh-keyscan ${self.private_ip} >> /home/ubuntu/.ssh/known_hosts" >> utils/4th.sh
    EOT
  }
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "allow"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "any" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.subnet.cidr_block]
  security_group_id = aws_security_group.sg.id
  description       = "any in subnet"
}

resource "aws_security_group_rule" "sg_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "ssh"
}

resource "aws_security_group_rule" "sg_lb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "lb"
}

resource "aws_security_group_rule" "sg_nodeport" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 30000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "nodeport"
}

resource "aws_security_group_rule" "sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
  description       = "outbound"
}

resource "aws_key_pair" "mykey" {
  key_name = "aws_key"
  public_key = "(사전에 생성해둔 공개키 내용 그대로 복사)"
}
