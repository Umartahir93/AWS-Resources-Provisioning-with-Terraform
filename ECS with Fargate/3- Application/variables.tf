
variable "region" {

}

variable "task_definition_name" {

}

locals  {
   docker_image_url =  data.terraform_remote_state.ecr_url.outputs.aws_ecr_url
}


variable "ecs_service_name" {

}

variable "memory" {

}

variable "docker_container_port" {
}


variable "desired_task_number" {
  
}

variable "cpu" {
  
}



      