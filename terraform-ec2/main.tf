provider "aws" {
  region = "eu-west-3"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"
  vpc_id      = "vpc-099eebb306d222379"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Changez pour votre IP publique pour plus de sécurité
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

# Création d'une instance EC2
resource "aws_instance" "example" {
  ami           = "ami-06e02ae7bdac6b938" # AMI Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ExampleInstance"
  }
}

# Création d'une alarme de budget
resource "aws_budgets_budget" "example_budget" {
  name              = "MonthlyBudget"
  budget_type       = "COST"
  limit_amount      = "10" # Limite mensuelle en USD
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  cost_types {
    include_tax       = true
    include_subscription = true
    use_blended       = false
  }
}

# Variables pour rendre le fichier modulaire
variable "instance_type" {
  default = "t2.micro"
}

variable "region" {
  default = "eu-west-3"
}

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
