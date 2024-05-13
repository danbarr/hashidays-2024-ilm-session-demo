variable "department" {
  type    = string
  default = "product-engineering"
}

variable "owner" {
  type    = string
  default = "frontend"
}

variable "base_image_bucket" {
  type    = string
  default = "node-20-hashicafe-base"
}

variable "base_image_channel" {
  type    = string
  default = "latest"
}

variable "registry_host" {
  type = string
}

variable "registry_is_ecr" {
  type = bool
}

variable "extra_tags" {
  type    = list(string)
  default = []
}
