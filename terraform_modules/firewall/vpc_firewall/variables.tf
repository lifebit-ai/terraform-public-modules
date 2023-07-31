variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "vpc_name" {
  description = "VPC Name."
  type        = string
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnets" {
  description = "Provide the details for the subnets"
  type        = map(any)
  default     = {}
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "VPC Region."
  type        = string
  default     = ""
}

variable "azs" {
  description = "VPZ AZS."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable one NatGateway in all Private subnets."
  type        = bool
  default     = false
}


variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC."
  type        = bool
  default     = false
}

variable "private_route_table_tags" {
  default = {}
}

variable "private_subnet_tags" {
  default = {}
}
