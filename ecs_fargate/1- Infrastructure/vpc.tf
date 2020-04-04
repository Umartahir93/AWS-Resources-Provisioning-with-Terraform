#VPC Resource
resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr

  tags = {
    Name = "Production-VPC"
  }
}

#Public Subnet #1
resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-1a"

  tags ={
    Name = "Public-Subnet-1"
  }
}

#Public Subnet #2
resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-1b"

  tags ={
    Name = "Public-Subnet-2"
  }
}

#Public Subnet #3
resource "aws_subnet" "public-subnet-3" {
  cidr_block        = var.public_subnet_3_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-1c"

  tags ={
    Name = "Public-subnet-3"
  }
}

#Private Subnet #1
resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-1a"

  tags ={
    Name = "Private-subnet-1"
  }
}

#Private Subnet #2
resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-1b"

  tags ={
    Name = "Private-subnet-2"
  }
}

#Private Subnet #3
resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = "us-east-1c"

  tags ={
    Name = "Private-Subnet-3"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Production-IGW"
  }
}

#Create a route table 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags ={
    Name = "Public-Route-Table"
  }
}

#Referenced the Internet gateway with this route resource
resource "aws_route" "public-internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

#Associate the routing table to the public subnet
resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}


#Associate the routing table to the public subnet
resource "aws_route_table_association" "public-subnet-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}


#Associate the routing table to the public subnet
resource "aws_route_table_association" "public-subnet-3-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-3.id
}


#Create a route table 
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}

#Associate the routing table to the private subnet
resource "aws_route_table_association" "private-subnet-1-assocaiation" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}


#Associate the routing table to the private subnet
resource "aws_route_table_association" "private-subnet-2-assocaiation" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}


#Associate the routing table to the private subnet
resource "aws_route_table_association" "private-subnet-3-assocaiation" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-3.id
}


#Create Elastic ip
resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

}

#Create a nat gateway and place it into public subnet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "Production-NAT-GW"
  }

  depends_on = [aws_eip.elastic-ip-for-nat-gw]

}

#Add route to nat gateway in private subnet
resource "aws_route" "nat_gw_route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"

}












