variable "tenminutevpn_region" {
  type = string
}

variable "tenminutevpn_version" {
  type = string
}

variable "squid_port" {
  type    = number
  default = 3128
}

variable "wireguard_port" {
  type    = number
  default = 51820
}

variable "wireguard_dns" {
  type    = list(string)
  default = ["1.1.1.1", "1.0.0.1"]
}
