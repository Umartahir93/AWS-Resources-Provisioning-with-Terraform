data "template_file" "ecs_task_definition_template" {
  template_file = "${file("task_definition.json")}"

vars{
    task_definition_name = var.task_definition_name
    ecs_service_name = var.task_definition_name
    docker_image_url = var.docker_image_url
    memory = var.memory
    docker_container_port = var.docker_container_port
    spring_profile = var.spring_profile
    region = var.region
}

}

resource "aws_ecs_task_definition" "springboot-task-definition" {
    container_definitions = data.template_file.ecs_task_definition_template.rendered
    family = var.service_name
    cpu = 512
    memory = var.memory
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role_policy.fargate_iam_role_policy
    task_role_arn = aws_iam_role_policy.fargate_iam_role_policy
   
}

resource "aws_iam_role" "fargate_iam_role" {
  name ="${var.ecs_service_name}-IAM-Role"
  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
} EOF 
}

resource "aws_iam_role_policy" "fargate_iam_role_policy" {
    name = "${var.ecs_service_name}-IAM-Role-Policy"
    role = aws_iam_role.fargate_iam_role.id

    policy = <<-EOF
{
        "Version":"2012-10-17",
        "Statement":[
            {
                "Effect":"Allow",
                "Action":[
                    "ecs:*",
                    "elasticloadbalancing:*",
                    "ecr:*",
                    "cloudwatch:*",
                    "logs:*"
                ],
                "Resource":"*"
            }
        ]
    }

    EOF
}


resource "aws_security_group" "app_security_group" {
  name = "${var.ecs_service_name}-SG"
  description = "Security group for springbootapp to communicate in and out"
  vpc_id =data.terraform_remote_state.platform.vpc.vpc_id

  ingress{
      from_port = 8080
      protocol = "TCP"
      to_port = 8080
      cidr_blocks= data.terraform_remote_state.platform.vpc.cidr_blocks
  }

  egress{
      from_port = 0
      protocol = "-1"
      to_port = 0
      cidr_blocks=["0.0.0.0/0"]
  }

  tags{
      Name="${var.ecs_service_name}-SG"
  }

}

resource "aws_alb_target_group" "ecs_app_target_group" {
  name = "${var.ecs_service_name}-TG"
  port = "${var.docker_container_port}"
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.platform.vpc.vpc_id
  target_type = "ip"

  health_check{
      path = "/actuator/health"
      protocol = "HTTP"
      matcher = "200"
      interval = 60
      timeout = 30
      unhealthy_threshold = "3"
      healthy_threashold = "3"
  }

  tags ={
      Name = "${var.ecs_service_name}-TG"
  }

}

resource "aws_ecs_service" "ecs_service" {
  name = var.ecs_service_name
  task_definition = var.ecs_service_name
  desired_count = var.desired_task_number
  cluster = data.terraform_remote_state.platform.ecs_cluster_name
  launch_type = "FARGATE"

  network_configuration{
    subnets = [data.terraform_remote_state.platform.ecs_public_subnets]
    security_groups = aws_security_group.app_security_group.id
    ass_public_ip = true
  }

load_balancer{
  container_name = var.ecs_service_name
  container_port = var.docker_container_port
  target_group_arn = aws_alb_target_group.ecs_app_target.arn
}

}

resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = data.terraform_remote_state.platform.ecs_alb_listener_arn

  action{
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn 
  }
}

resource "aws_cloudwatch_log_group" "springbootapp_log_group" {
  name = "Log group"

}





