
output "FGTActiveMGMTPublicIP" {
  value = aws_eip.MGMTPublicIP.public_ip
}

output "FGTClusterPublicFQDN" {
  value = join("", tolist(["https://", "${aws_eip.ClusterPublicIP.public_dns}", ":", "${var.adminsport}"]))
}

output "FGTClusterPublicIP" {
  value = aws_eip.ClusterPublicIP.public_ip
}


output "FGTPassiveMGMTPublicIP" {
  value = try(aws_eip.PassiveMGMTPublicIP[0].public_ip, "")
}

output "Username" {
  value = "admin"
}

output "Password" {
  value = try(module.fgtactive.id, "")
}
