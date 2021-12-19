variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS Region"
}

variable "customer_name" {
  type        = string
  default     = "test"
  description = "Customer name, For example: DOS"
}

variable "account_name" {
  type        = string
  default     = "Prod"
  description = "Account Name, Dev or Prod"
}

variable "VPC_CIDR" {
  type        = string
  default     = "10.1.0.0/16"
  description = "VPC CIDR range"
}

variable "public_subnets_names" {
  type    = set(string)
  default = ["pub-sub-01", "pub-sub-02"]
}

variable "public_subnets" {
  type    = set(string)
  default = ["10.1.2.0/24"]
}

variable "private_subnets_names" {
  type    = set(string)
  default = ["prv-sub-01", "prv-sub-02"]
}

variable "private_subnets" {
  type    = set(string)
  default = ["10.1.2.0/24", "10.1.3.0/24"]
}

