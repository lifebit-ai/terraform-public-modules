variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "region" {
  description = "Default AWS region"
  type        = string
  default     = "eu-west-2"
}

// Availability zone 1 for the region
variable "az1" {
  description = "Availability Zone 1"
  type        = string
  default     = "eu-west-2a"
}

// Availability zone 2 for the region
variable "az2" {
  description = "Availability Zone 1"
  type        = string
  default     = "eu-west-2b"
}

variable "private_route_table_id" {
  description = "Private route table ID for the internal traffics"
}

variable "vpcid" {
  type        = string
  description = "VPC ID"
}

variable "vpccidr" {
  description = "VPC complete CIDR block"
}

variable "publiccidraz1id" {
  description = "Public Subnet 1 AZ1 ID"
}

variable "privatecidraz1id" {
  description = "Private Subnet 1 AZ1 ID"
}

variable "hasynccidraz1id" {
  description = "HASYNC Subnet 1 AZ1 ID"
}

variable "hamgmtcidraz1id" {
  description = "HAMGMT Subnet 1 AZ1 ID"
}

variable "publiccidraz2id" {
  description = "Public Subnet 1 AZ2 ID"
}

variable "privatecidraz2id" {
  description = "Private Subnet 1 AZ2 ID"
}

variable "hasyncidraz2id" {
  description = "HASYNC Subnet 1 AZ2 ID"
}

variable "hamgmtidraz2id" {
  description = "HAMGMT Subnet 1 AZ2 ID"
}


// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "payg"
}


// instance type needs to match the architect
// c5n.xlarge is x86_64
// c6g.xlarge is arm
// For detail, refer to https://aws.amazon.com/ec2/instance-types/
variable "size" {
  default = "c6g.xlarge"
}

variable "ami" {
  description = "FortiGate-VM64-AWSONDEMAND build1262 (7.2.3) GA"
  default     = "ami-0cf32751817ec5915"
}


//  Existing SSH Key on the AWS
variable "keyname" {
  default = "<AWS SSH KEY>"
}

// HTTPS access port
variable "adminsport" {
  default = "10443"
}

variable "public_access_ip_list" {
  description = ""
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "public_access_ips" {
  description = ""
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnetmask" {
  default = "255.255.255.192"
}

variable "activeport1gateway" {
  description = "gateway IP for the public subnet for AZ1"

}

variable "activeport2gateway" {
  description = "gateway IP for the private subnet for AZ1"

}

variable "activeport4gateway" {
  description = "gateway IP for the management subnet for AZ1"

}

variable "passiveport1gateway" {
  description = "gateway IP for the public subnet for AZ2"
}

variable "passiveport2gateway" {
  description = "gateway IP for the private subnet for AZ2"
}

variable "passiveport4gateway" {
  description = "gateway IP for the management subnet for AZ2"
}

variable "run_ngfw" {
  default = true
}

variable "run_passive_ngfw" {
  default = false
}

variable "mgmt_access_ip_list" {
  description = ""
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bootstrap-active" {
  // Change to your own path
  type    = string
  default = "config/config-active.tpl"
}

variable "bootstrap-passive" {
  // Change to your own path
  type    = string
  default = "config/config-passive.tpl"
}

variable "iam_instance_profile" {
  description = "provide the instance profile name"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.lic"
}

// license file for the passive fgt
variable "license2" {
  // Change to your own byol license file, license2.lic
  type    = string
  default = "license2.lic"
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type = object({
    http_endpoint               = string
    http_put_response_hop_limit = string
    http_tokens                 = string
  })
  default = {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "required"
  }
}

variable "client" {
  type = string
}
