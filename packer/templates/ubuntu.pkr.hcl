variable "aws_region" {
  default = "${var.aws_region}"
}

variable "subnet_id" {
  default = "${var.aws_subnet_id}"
}

variable "iam_profile" {
  default = "${var.aws_iam_instance_profile}"
}

variable "source_ami" {
  default = "${var.aws_source_ubuntu_ami}"
}

source "amazon-ebs" "ubuntu" {
  region              = var.aws_region
  instance_type       = "t3.micro"
  subnet_id           = var.subnet_id
  iam_instance_profile = var.iam_profile
  ami_name            = "golden-ami-ubuntu-24"
  source_ami_filter {
    filters = {
      name = var.source_ami
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {
    playbook_file = "../ansible/playbooks/cis-hardening.yml"
  }

  provisioner "shell" {
    script = "../packer/scripts/install_packages.sh"
  }
}
