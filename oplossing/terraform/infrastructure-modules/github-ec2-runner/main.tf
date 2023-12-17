# Creates a security group for the GitHub Runner
resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound traffic to port 443"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic to all destinations"
  }

  tags = {
    Name = var.security_group_name
  }
}

# Creates a GitHub Runner EC2 instance
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_role

  user_data = <<-EOF
              #!/bin/bash
              su - ec2-user <<'USER_DATA_EOF'
              mkdir /home/ec2-user/actions-runner && cd /home/ec2-user/actions-runner
              curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
              tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
              ./config.sh --url https://github.com/PXL-Systems-Expert/kubernetes-pe2-KhalidAitBouzidPXL --token ${var.runner_token} --name ${var.runner_name} --unattended --replace
              echo -e "[Unit]\nDescription=GitHub Actions Runner\n\n[Service]\nExecStart=/home/ec2-user/actions-runner/run.sh\nUser=ec2-user\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/actions-runner.service
              sudo systemctl enable actions-runner
              sudo systemctl start actions-runner
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo yum install git -y
              sudo systemctl start docker
              sudo usermod -a -G docker ec2-user
              newgrp docker
              sudo chmod 666 /var/run/docker.sock
              sudo systemctl restart docker
              sudo systemctl enable docker
              USER_DATA_EOF
              EOF

  tags = {
    Name = var.instance_name
  }
}