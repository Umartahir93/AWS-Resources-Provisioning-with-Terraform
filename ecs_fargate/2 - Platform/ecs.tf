#ECS Cluster
resource "aws_ecs_cluster" "production-fargate-cluster" {
  name = "Production-Fargate-Cluster"
}



#Application Load Balancer
resource "aws_alb" "ecs_cluster_alb" {
  name            = var.ecs_cluster_name
  internal        = false
  security_groups = [aws_security_group.ecs_alb_security_group.id]
  subnets         = data.terraform_remote_state.infrastructure.outputs.public_subnets

  tags = {
    Name = "${var.ecs_cluster_name} - Application Load Balancer"
  }
}
#Target group
resource "aws_alb_target_group" "ecs_default_target_group" {
  name     = var.ecs_cluster_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infrastructure.outputs.vpc_id
  target_type = "ip"

  health_check{
      path = "/actuator/health"
      protocol = "HTTP"
      matcher = "200"
      interval = 60
      timeout = 30
      unhealthy_threshold = "3"
      healthy_threshold = "3"
  }
  tags ={
      Name = "${var.ecs_cluster_name}-TG"
  }

}

#Load balancer's listener
resource "aws_alb_listener" "ecs_alb_http_listener" {
  load_balancer_arn = aws_alb.ecs_cluster_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
  }

  depends_on = [aws_alb_target_group.ecs_default_target_group]
}