variable "prefix" {
  default = "hello1234a"
}

variable "ssh_key" {
  default = "~/.ssh/id_rsa_ec2_instance.pub"
}

variable "init_install" {
  default = "~/github/terraform-cloudops/infra/scripts/init_install.sh"
}