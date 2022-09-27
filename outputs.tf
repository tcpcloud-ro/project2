output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.arn
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnet_[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public_subnet_[*].arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.public_subnet[*].cidr_block)
}

output "sg_frontend_arn" {
  value       = sg_frontend.arn
}

output "igw_arn" {
  value       = igwn.arn
}

output "route_table_frontend_arn" {
  value       = route_table_frontend.arn
}