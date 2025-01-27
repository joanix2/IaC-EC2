# Configurez le fournisseur AWS
provider "aws" {
  region = "eu-west-3"
}

# Chemin vers la clé publique (assurez-vous que ce chemin est correct)
variable "public_key_path" {
  default = "~/.ssh/aws_key.pem.pub"
}

variable "private_key_path" {
  default = "~/.ssh/aws_key.pem"
}


# Créez une clé SSH
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file(var.public_key_path)
}

# Créez un groupe de sécurité
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Security group for EC2 instance"

  # Autorisez le trafic SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Changez par votre IP publique pour plus de sécurité
  }

  # Autorisez tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Créez une instance EC2
resource "aws_instance" "example" {
  ami           = "ami-06e02ae7bdac6b938" # Update with a valid AMI ID for us-west-2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.example.id]

  # Script Bash à exécuter au démarrage
  user_data = <<-EOF
    #!/bin/bash
    sudo snap install docker
  EOF

  # Configurez la connexion SSH
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
}

# Affichez l'adresse IP publique de l'instance
output "public_ip" {
  value = aws_instance.example.public_ip
}

# Affichez l'adresse DNS publique de l'instance
output "public_dns" {
  value = aws_instance.example.public_dns
}
