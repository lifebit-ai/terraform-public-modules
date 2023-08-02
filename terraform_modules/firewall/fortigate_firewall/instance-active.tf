// FGTVM active instance

resource "aws_network_interface" "eth0" {
  description = "active-port1"
  subnet_id   = var.publiccidraz1id
}

resource "aws_network_interface" "eth1" {
  description       = "active-port2"
  subnet_id         = var.privatecidraz1id
  source_dest_check = false
}


resource "aws_network_interface" "eth2" {
  description       = "active-port3"
  subnet_id         = var.hasynccidraz1id
  source_dest_check = false
}


resource "aws_network_interface" "eth3" {
  description = "active-port4"
  subnet_id   = var.hamgmtcidraz1id
}


resource "aws_network_interface_sg_attachment" "publicattachment" {
  depends_on           = [aws_network_interface.eth0]
  security_group_id    = module.sg_alb_public.security_group_id
  network_interface_id = aws_network_interface.eth0.id
}


resource "aws_network_interface_sg_attachment" "mgmtattachment" {
  depends_on           = [aws_network_interface.eth3]
  security_group_id    = module.sg_alb_public.security_group_id
  network_interface_id = aws_network_interface.eth3.id
}

resource "aws_network_interface_sg_attachment" "internalattachment" {
  depends_on           = [aws_network_interface.eth1]
  security_group_id    = module.sg_alb_allow_all.security_group_id
  network_interface_id = aws_network_interface.eth1.id
}

resource "aws_network_interface_sg_attachment" "hasyncattachment" {
  depends_on           = [aws_network_interface.eth2]
  security_group_id    = module.sg_alb_allow_all.security_group_id
  network_interface_id = aws_network_interface.eth2.id
}

data "template_file" "fgtactive" {
  template = file("${path.module}/${var.bootstrap-active}")
  vars = {
    type            = var.license_type
    license_file    = var.license
    port1_ip        = aws_network_interface.eth0.private_ip
    port1_mask      = var.subnetmask
    port2_ip        = aws_network_interface.eth1.private_ip
    port2_mask      = var.subnetmask
    port3_ip        = aws_network_interface.eth2.private_ip
    port3_mask      = var.subnetmask
    port4_ip        = aws_network_interface.eth3.private_ip
    port4_mask      = var.subnetmask
    passive_peerip  = aws_network_interface.passiveeth2.private_ip
    mgmt_gateway_ip = var.activeport4gateway
    defaultgwy      = var.activeport1gateway
    privategwy      = var.activeport2gateway
    vpc_ip          = cidrhost(var.vpccidr, 0)
    vpc_mask        = cidrnetmask(var.vpccidr)
    adminsport      = var.adminsport
    client          = title(lower(var.client))
  }
}

module "fgtactive" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  create               = var.run_ngfw
  ami                  = var.ami
  name                 = "FortiGateVM Active"
  instance_type        = var.size
  availability_zone    = var.az1
  key_name             = var.keyname
  user_data            = data.template_file.fgtactive.rendered
  iam_instance_profile = var.iam_instance_profile

  root_block_device = [{
    volume_type = "standard"
    volume_size = "2"
  }]
  ebs_block_device = [{
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
    }
  ]
  network_interface = [
    {
      network_interface_id = aws_network_interface.eth0.id
      device_index         = 0
    },
    {
      network_interface_id = aws_network_interface.eth1.id
      device_index         = 1
    },
    {
      network_interface_id = aws_network_interface.eth2.id
      device_index         = 2
    },
    {
      network_interface_id = aws_network_interface.eth3.id
      device_index         = 3
    }
  ]
  metadata_options = var.metadata_options
}
