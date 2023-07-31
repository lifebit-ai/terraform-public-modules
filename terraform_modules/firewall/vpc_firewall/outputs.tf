output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this.id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this.arn, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this.cidr_block, "")
}

output "subnet_arns" {
  description = "Public subnets ARN we created."
  value       = { for k, v in aws_subnet.subnet : k => v.arn }
}


output "subnet_ids" {
  description = "Public subnets IDs we created."
  value       = { for k, v in aws_subnet.subnet : k => v.id }
}


output "route_table_ids" {
  value = { for k, v in aws_route_table.route-table : k => v.id }
}

output "subnet_details" {
  description = "Public subnets ARN we created."
  value       = { for k, v in aws_subnet.subnet : k => { arn = v.arn, id = v.id, cidr = v.cidr_block } }
}
