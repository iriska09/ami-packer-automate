packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "1.0.3" # Change to the latest available version
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "1.0.0" # Change to the latest available version
    }
  }
}
