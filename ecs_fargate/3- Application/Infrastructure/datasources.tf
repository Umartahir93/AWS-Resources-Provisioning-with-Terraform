data "terraform_remote_state" "platform" {
  backend = "s3"

  config = {
    key    = "env:/dev-env/ecs_fargate/platform.tfstate"
    bucket = "umartahir-terraform-buckettestus-east-1"
    region = "us-east-1"
  }
}

data "aws_iam_policy_document" "ecs-task-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs-task-execution-role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
