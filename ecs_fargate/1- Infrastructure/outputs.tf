output "vpc_id" {
  value = aws_vpc.production-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production-vpc.cidr_block
}

output "public_subnets" {
  value = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]          
}

output "private_subnets" {
  value = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id,aws_subnet.private-subnet-3.id]
}

