# AWS VPC Terraform module

Terraform module used to create VPCs.

## Usage

### VPC Creation

VPC Creation:

```hcl
terraform {
  source = "git::git@github.com:lifebit-ai/lifebit-infrastructure-modules.git//2-supermodules/networking/vpc_firewall?ref=<version>"
}

include {
  path = find_in_parent_folders()
}

locals {
  client      = read_terragrunt_config(find_in_parent_folders("client.hcl"))
  datacenter  = read_terragrunt_config(find_in_parent_folders("datacenter.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

inputs = {
  name = local.datacenter.locals.aws_main_vpc_name
  vpc_cidr             = local.client.locals[local.environment.locals.environment].network.vpc_cidr
  subnets              = local.client.locals[local.environment.locals.environment].network.subnets
  region               = local.datacenter.locals.aws_region
  environment          = local.environment.locals.environment
  enable_dns_hostnames = true
}
```

## Sample values

```hcl
  networking = {
    network = {
      vpc_cidr = "10.33.0.0/22"
      subnets = {
        PublicSubnetA = {
          SubnetCIDR        = "10.33.0.0/26"
          availability_zone = "eu-west-2a"
          route-table       = "public-route-table"
          Public            = true
        },
        PublicSubnetB = {
          SubnetCIDR        = "10.33.1.0/26"
          availability_zone = "eu-west-2b"
          route-table       = "public-route-table"
          Public            = true
        },
        PrivateSubnetA = {
          SubnetCIDR        = "10.33.0.64/26"
          availability_zone = "eu-west-2a"
          route-table       = "private-route-table"
        },
        PrivateSubnetB = {
          SubnetCIDR        = "10.33.1.64/26"
          availability_zone = "eu-west-2b"
          route-table       = "private-route-table"
        },
        HeartbeatSubnetA = {
          SubnetCIDR        = "10.33.0.128/26"
          availability_zone = "eu-west-2a"
          route-table       = "heartbeat-route-table"
        },
        HeartbeatSubnetB = {
          SubnetCIDR        = "10.33.1.128/26"
          availability_zone = "eu-west-2b"
          route-table       = "heartbeat-route-table"
        },
        MgmtSubnetA = {
          SubnetCIDR        = "10.33.0.192/26"
          availability_zone = "eu-west-2a"
          route-table       = "public-route-table"
          Public            = true
        },
        MgmtSubnetB = {
          SubnetCIDR        = "10.33.1.192/26"
          availability_zone = "eu-west-2b"
          route-table       = "public-route-table"
          Public            = true
        }
      }
    }
```


## Assumptions

It has no requirements.

## Notes
