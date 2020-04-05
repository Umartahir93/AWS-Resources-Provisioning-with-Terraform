output "vpc_id" {
  value = data.terraform_remote_state.infrastructure.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.infrastructure.outputs.vpc_cidr_block
}

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.ecs_default_target_group.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.production-fargate-cluster.name
}

output "ecs_public_subnets" {
  value = data.terraform_remote_state.infrastructure.outputs.public_subnets
}

output "ecs_private_subnets" {
  value = data.terraform_remote_state.infrastructure.outputs.private_subnets
}

