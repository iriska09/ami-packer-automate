variable "aws_region" {}
variable "subnet_id" {}
variable "iam_profile" {}
variable "source_ami" {}

source "amazon-ebs" "amazon_linux" {
  region              = var.aws_region
  instance_type       = "t3.micro"
  subnet_id           = var.subnet_id
  iam_instance_profile = var.iam_profile
  ami_name            = "golden-ami-amazon-linux3"
  source_ami_filter {
    filters = {
      name = var.source_ami
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.amazon_linux"]

  provisioner "ansible" {
    playbook_file = "../ansible/playbooks/cis-hardening.yml"
  }

  provisioner "shell" {
    script = "../packer/scripts/install_packages.sh"
  }
}
