variable "aws_region" {}
variable "subnet_id" {}
variable "iam_profile" {}
variable "source_ami" {}

source "amazon-ebs" "amazon_linux" {
  region                  = var.aws_region
  instance_type           = "t3.micro"
  ssh_username            = "ec2-user"
  source_ami              = var.source_ami
  subnet_id               = var.subnet_id
  ami_name            = "secure-amazon-linux3-2025"
  associate_public_ip_address = true
    metadata_options {
    http_tokens = "optional"
    }
    user_data = <<EOF
    #!/bin/bash
    echo "Forcing SSH key injection..."
    cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/authorized_keys
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
