#Fargate ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  task_definition = aws_ecs_task_definition.springboot-task-definition.arn
  cluster         = data.terraform_remote_state.platform.outputs.ecs_cluster_name
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.platform.outputs.ecs_public_subnets
    security_groups  = [aws_security_group.app_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = var.task_definition_name
    container_port   = var.docker_container_port
    target_group_arn = data.terraform_remote_state.platform.outputs.aws_alb_target_group_arn
  }
  desired_count = 2
}

#Task definition
resource "aws_ecs_task_definition" "springboot-task-definition" {
  container_definitions = data.template_file.ecs_task_definition_template.rendered
  family                = var.task_definition_name
  

  cpu                      = 512
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.fargate_iam_role.arn
  task_role_arn      = aws_iam_role.fargate_iam_role.arn

}

resource "aws_iam_role" "fargate_iam_role" {
  name = "fargate_iam_role"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-assume-role.json
}

resource "aws_iam_role_policy_attachment" "fargate_iam_role_policy" {
  role = aws_iam_role.fargate_iam_role.name
  policy_arn = data.aws_iam_policy.ecs-task-execution-role.arn
}

#Security Group
resource "aws_security_group" "app_security_group" {
  name        = "${var.ecs_service_name}-SG"
  description = "Security group for springbootapp to communicate in and out"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id

  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = [data.terraform_remote_state.platform.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ecs_service_name}-SG"
  }

}

#CloudWatch
resource "aws_cloudwatch_log_group" "springbootapp_log_group" {
  name = "Log-group"
}






