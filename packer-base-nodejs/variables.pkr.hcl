variable "department" {
  type    = string
  default = "platform-services"
}

variable "owner" {
  type    = string
  default = "releng"
}

variable "registry_host" {
  type = string
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type      = string
  sensitive = true
}
