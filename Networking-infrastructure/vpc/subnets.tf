#Public Subnets in three AZ
resource "aws_subnet" "public" {
  count = "${length(var.availability_zones)}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public Subnet - ${element(var.availability_zones,count.index)}"
  }
}

#Private Subnets in three AZ
resource "aws_subnet" "private" {
  count = "${length(var.availability_zones)}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false
  
  tags = {
    Name = "Private Subnet - ${element(var.availability_zones,count.index)}"
  }
}

#elastic ips
resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"
  vpc      = true
}

#Nat Gateway in three AZ for high availability
resource "aws_nat_gateway" "main" {
  count = "${length(var.availability_zones)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  tags = {
    Name = "NAT - ${element(var.availability_zones,count.index)}"
  }
}

