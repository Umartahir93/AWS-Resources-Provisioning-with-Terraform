resource "aws_ecs_cluster" "production-fargate-cluster" {
  name = "Production-Fargate-Cluster"
}

resource "aws_alb" "ecs_cluster_alb" {
  name            = var.ecs_cluster_name
  internal        = false
  security_groups = [aws_security_group.ecs_alb_security_group]
  subnets         = [split(",", join(",", data.terraform_remote_state.infrastructure.public_subnets))]

  tags = {
    Name = "${var.ecs_cluster_name - ALB}"
  }
}

resource "aws_alb_listener" "ecs_alb_http_listener" {
  load_balancer_arn = aws_alb.ecs_cluster_alb
  port              = 80
  protocol          = "HTTP"

  #Indicate how this listener will route traffic that is not otherwise routed by a another rule.
  #Ask about this
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
  }

  depends_on = [aws_alb_target_group.ecs_default_target_group]
}

resource "aws_alb_target_group" "ecs_default_target_group" {
  name     = "${var.ecs_cluster_name} - TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infrastructure.vpc_id

  tags = {
    Name = "${var.ecs_cluster_name} - TG"
  }

}

resource "aws_iam_role" "ecs_cluster_role" {
  name               = "${var.ecs_cluster_name}-IAM-Role"
  assume_role_policy = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect":"Allow",
              "Principal":{
                  "Service": ["ecs.amazonaws.com",
                  "ec2.amazonaws.com", 
                  "application-autoscaling.amazonaws.com"
                  ]
              },
              "Action":"sts:AssumeRole"
          }
      ]
  }
    EOF
}

resource "aws_iam_role_policy" "ecs_cluster_policy" {
  name   = "${var.ecs_cluster_name} -IAM-Policy"
  role   = aws_iam_role.ecs_cluster_role.id
  policy = <<EOF
    {
        "Version":"2012-10-17"
        "Statement":[
            {
                "Effect":"Allow"
                "Action":[
                    "ecs:*",
                    "ec2:*",
                    "elasticloadbalancing:*",
                    "ecr:*",
                    "dynamodb:*",
                    "cloudwatch:*",
                    "s3:*",
                    "rds:*",
                    "sqs:*",
                    "sns:*",
                    "logs:*",
                    "ssm:*"
                ],
                "Resource":"*"
            }
        ]
    }
    EOF

}