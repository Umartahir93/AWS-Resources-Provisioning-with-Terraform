#ASK ABOUT NOTE
####################################################
#NOTE on Route Tables and Routes: Terraform 
#currently provides both a standalone Route 
#resource and a Route Table resource with routes 
#defined in-line. At this time you cannot use a 
#Route Table with in-line routes in conjunction 
#with any Route resources. Doing so will cause a 
#conflict of rule settings and will overwrite rules.
#####################################################

#public route table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "public route table"
  }

}

#routing rule
resource "aws_route" "public_internet_gateway" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

#creat a route rule association for all the public subnets
resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


#private route table
resource "aws_route_table" "private" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "private route table - ${element(var.availability_zones,count.index)}"
  }
  
}

#routing rule
resource "aws_route" "nat_gateway" {
  count = "${length(var.availability_zones)}"
  route_table_id            = "${element(aws_route_table.private.*.id,count.index)}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.main.*.id,count.index)}"
}

#creat a route rule association for all the private subnets
resource "aws_route_table_association" "private" {
  count = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}





