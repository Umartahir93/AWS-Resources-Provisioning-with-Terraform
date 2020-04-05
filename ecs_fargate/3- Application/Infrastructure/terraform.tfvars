ecs_service_name      = "springbootapp"
docker_container_port = 8080
desired_task_number   = "1"
spring_profile        = "default"
memory                = 1024
docker_image_url      = "nginx:latest"
region                = "us-east-1"
task_definition_name  = "ecs-task-for-java-app"