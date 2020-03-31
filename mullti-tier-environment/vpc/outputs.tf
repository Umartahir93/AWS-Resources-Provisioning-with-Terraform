output "vpc_tf" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "public_cidrs" {
  value = "${aws_subnet.public.*.cidr_block}"
}

output "private_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "private_cidrs" {
  value = "${aws_subnet.private.*.cidr_block}"
}
output "terraform_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

