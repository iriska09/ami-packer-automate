variable "aws_region" {}
variable "subnet_id" {}
variable "iam_instance_profile" {}
variable "source_ami" {}
variable "key_pair_name" {}  # ✅ Explicitly define key_pair_name

source "amazon-ebs" "amazon_linux" {
  region                  = var.aws_region
  instance_type           = "t3.micro"
  source_ami              = var.source_ami
  subnet_id               = var.subnet_id
  ssh_username            = "ec2-user"
  ami_name                = "secure-amazon-linux3-2025"
  key_pair_name           = var.key_pair_name  # ✅ Uses predefined key
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "optional"
  }

  user_data = <<EOF
#!/bin/bash
echo "Ensuring SSH key is injected..."
mkdir -p /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh
touch /home/ec2-user/.ssh/authorized_keys
chmod 600 /home/ec2-user/.ssh/authorized_keys
EOF
}

build {
  sources = ["source.amazon-ebs.amazon_linux"]

  provisioner "shell" {
    script = "packer/scripts/install_packages.sh"
  }

  provisioner "ansible" {
    playbook_file = "ansible/playbooks/cis-hardening.yml"
  }
}
