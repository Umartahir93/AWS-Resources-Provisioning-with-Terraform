#Template file to read Task definition's json
data "template_file" "ecs_task_definition_template" {
  template = "${file("task-definition.json")}"

  vars = {
    task_definition_name  = var.task_definition_name
    ecs_service_name      = var.task_definition_name
    docker_image_url      = local.docker_image_url
    memory                = var.memory
    docker_container_port = var.docker_container_port
    region                = var.region
  }
}