// Creating Public EIP address
resource "aws_eip" "ClusterPublicIP" {
  depends_on        = [module.fgtactive]
  vpc               = true
  network_interface = aws_network_interface.eth0.id
}

resource "aws_eip" "MGMTPublicIP" {
  depends_on        = [module.fgtactive]
  vpc               = true
  network_interface = aws_network_interface.eth3.id
}

resource "aws_eip" "PassiveMGMTPublicIP" {
  count = var.run_passive_ngfw ? 1 : 0

  depends_on        = [module.fgtpassive]
  vpc               = true
  network_interface = aws_network_interface.passiveeth3.id
}

resource "aws_route" "internalroute" {
  count                  = var.run_ngfw ? 1 : 0
  depends_on             = [module.fgtactive]
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.eth1.id
}


// Security Group


module "sg_alb_public" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s%s", "sg_alb", "public")
  description = format("%s%s", "Security group for ALB", "public")
  vpc_id      = var.vpcid
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "ALB_HTTP"
      cidr_blocks = var.public_access_ips
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "ALB_HTTPS"
      cidr_blocks = var.public_access_ips
    },
    {
      from_port   = 10443
      to_port     = 10443
      protocol    = "tcp"
      description = "ALB_HTTPS"
      cidr_blocks = var.public_access_ips
    },
  ]
}

module "sg_alb_allow_all" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s%s", "sg_alb", "AllowAll")
  description = format("%s%s", "Security group for ALB", " internal and ha sync")
  vpc_id      = var.vpcid
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },

  ]
}
