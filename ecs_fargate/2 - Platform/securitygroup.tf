resource "aws_security_group" "ecs_alb_security_group" {
  name        = "${var.ecs_cluster_name}-ALB-SG"
  description = "Security Group for ALB to traffic for ECS cluster"
  vpc_id      = data.terraform_remote_state.infrastructure

  ingress {
    from_port  = 80
    protocol   = "TCP"
    to_port    = 80
    cidr_block = [var.internet_cidr_blocks]
  }

  egress {
    from_port  = 0
    protocol   = "-1"
    to_port    = 0
    cidr_block = [var.internet_cidr_blocks]
  }

}
