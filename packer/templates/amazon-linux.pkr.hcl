variable "aws_region" {}
variable "subnet_id" {}
variable "iam_profile" {}
variable "source_ami" {}

source "amazon-ebs" "amazon_linux" {
  region              = var.aws_region
  instance_type       = "t3.micro"
  ssh_username        = "ec2-user"
  source_ami          = var.source_ami
  subnet_id           = var.subnet_id
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
echo "Enabling SSH access..."
systemctl enable ssh
systemctl start ssh
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
