################### Network Variables
variable "region" {
  type        = string
  default     = "us-east-1"
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
  default     = "10.0.0.0/16"
  description = "VPC CIDR range"
}

variable "public_subnets_names" {
  type    = list(string)
  default = ["pub-sub-01", "pub-sub-02", "pub-sub-03","pub-sub-04"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.5.0/24","10.0.8.0/24"]
}

variable "private_subnets_names" {
  type    = list(string)
  default = ["prv-sub-01", "prv-sub-02", "prv-sub-03"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

################### Servers Variables

variable "security_groups_names" {
  type    = list(string)
  default = ["SG1","SG2"]
}