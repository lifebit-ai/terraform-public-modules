locals {
  route_tables = distinct([for route in var.subnets : route.route-table])
  public_route_table = distinct(
    flatten([
      for subnet in var.subnets :
      lookup(subnet, "Public", false) ? [subnet.route-table] : []
      ]
    )
  )
}


// AWS VPC - FG
resource "aws_vpc" "this" {

  cidr_block = var.vpc_cidr


  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  # enable_classiclink             = null # https://github.com/hashicorp/terraform/issues/31730
  # enable_classiclink_dns_support = null # https://github.com/hashicorp/terraform/issues/31730

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}


resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.SubnetCIDR
  availability_zone = each.value.availability_zone

  tags = merge(
    {
      Name = each.key
    },
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    { "Name" = "${var.name}-IGW" },
    var.tags,
    var.igw_tags,
  )
}


resource "aws_route_table" "route-table" {
  for_each = toset(local.route_tables)

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = each.key
    },
    var.tags,
    var.private_route_table_tags,
  )
}

resource "aws_route" "externalroute" {
  for_each = toset(local.public_route_table)

  route_table_id         = aws_route_table.route-table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "subnet-association" {
  for_each       = var.subnets
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.route-table[each.value.route-table].id
}
