variable "aws_region" {}
variable "subnet_id" {}
variable "iam_profile" {}
variable "source_ami" {}

source "amazon-ebs" "ubuntu" {
  region              = var.aws_region
  instance_type       = "t3.micro"
  subnet_id           = var.subnet_id
  iam_instance_profile = var.iam_profile
  ami_name            = "golden-ami-ubuntu-24"
  source_ami          = var.source_ami
  ssh_username        = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {
    playbook_file = "ansible/playbooks/cis-hardening.yml"
  }

  provisioner "shell" {
    script = "packer/scripts/install_packages.sh"
  }
}
