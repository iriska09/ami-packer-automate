packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "latest"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "latest"
    }
  }
}
