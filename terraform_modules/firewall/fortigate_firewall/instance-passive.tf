// FGTVM active instance

resource "aws_network_interface" "passiveeth0" {
  description = "passive-port1"
  subnet_id   = var.publiccidraz2id
}

resource "aws_network_interface" "passiveeth1" {
  description       = "passive-port2"
  subnet_id         = var.privatecidraz2id
  source_dest_check = false
}


resource "aws_network_interface" "passiveeth2" {
  description       = "passive-port3"
  subnet_id         = var.hasyncidraz2id
  source_dest_check = false
}


resource "aws_network_interface" "passiveeth3" {
  description = "passive-port4"
  subnet_id   = var.hamgmtidraz2id
}


resource "aws_network_interface_sg_attachment" "passivepublicattachment" {
  depends_on           = [aws_network_interface.passiveeth0]
  security_group_id    = module.sg_alb_public.security_group_id
  network_interface_id = aws_network_interface.passiveeth0.id
}


resource "aws_network_interface_sg_attachment" "passivemgmtattachment" {
  depends_on           = [aws_network_interface.passiveeth3]
  security_group_id    = module.sg_alb_public.security_group_id
  network_interface_id = aws_network_interface.passiveeth3.id
}

resource "aws_network_interface_sg_attachment" "passiveinternalattachment" {
  depends_on           = [aws_network_interface.passiveeth1]
  security_group_id    = module.sg_alb_allow_all.security_group_id
  network_interface_id = aws_network_interface.passiveeth1.id
}

resource "aws_network_interface_sg_attachment" "passivehasyncattachment" {
  depends_on           = [aws_network_interface.passiveeth2]
  security_group_id    = module.sg_alb_allow_all.security_group_id
  network_interface_id = aws_network_interface.passiveeth2.id
}

data "template_file" "fgtpassive" {
  template = file("${path.module}/${var.bootstrap-passive}")
  vars = {
    type            = var.license_type
    license_file    = var.license2
    port1_ip        = aws_network_interface.passiveeth0.private_ip
    port1_mask      = var.subnetmask
    port2_ip        = aws_network_interface.passiveeth1.private_ip
    port2_mask      = var.subnetmask
    port3_ip        = aws_network_interface.passiveeth2.private_ip
    port3_mask      = var.subnetmask
    port4_ip        = aws_network_interface.passiveeth3.private_ip
    port4_mask      = var.subnetmask
    active_peerip   = aws_network_interface.eth2.private_ip
    mgmt_gateway_ip = var.passiveport4gateway
    defaultgwy      = var.passiveport1gateway
    privategwy      = var.passiveport2gateway
    vpc_ip          = cidrhost(var.vpccidr, 0)
    vpc_mask        = cidrnetmask(var.vpccidr)
    adminsport      = var.adminsport
    client          = title(lower(var.client))
  }
}


module "fgtpassive" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  create               = var.run_ngfw && var.run_passive_ngfw ? true : false
  depends_on           = [module.fgtactive]
  name                 = "FortiGateVM Passive"
  ami                  = var.ami
  instance_type        = var.size
  availability_zone    = var.az2
  key_name             = var.keyname
  user_data            = data.template_file.fgtpassive.rendered
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
      network_interface_id = aws_network_interface.passiveeth0.id
      device_index         = 0
    },
    {
      network_interface_id = aws_network_interface.passiveeth1.id
      device_index         = 1
    },
    {
      network_interface_id = aws_network_interface.passiveeth2.id
      device_index         = 2
    },
    {
      network_interface_id = aws_network_interface.passiveeth3.id
      device_index         = 3
    }
  ]
  metadata_options = var.metadata_options
}
