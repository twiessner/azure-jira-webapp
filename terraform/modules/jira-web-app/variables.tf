
variable "env" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "tags" {
  type = map(string)
}