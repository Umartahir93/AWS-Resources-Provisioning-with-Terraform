ecs_service_name      = "generalapplication"
docker_container_port = 80
desired_task_number   = "1"
cpu                   = 512
memory                = 1024
#docker_image_url      = data.terraform_remote_state.ecr_url.outputs.aws_ecr_url
region                = "us-east-1"
task_definition_name  = "nginxtaskdefinition"
