resource "aws_codebuild_project" "code_build_stage_pipeline" {
  name         = var.code_build_stage_project_name
  service_role = aws_iam_role.example.arn

  artifacts {
    type = var.codebuild_stage_artifact
  }

  environment {
    compute_type    = var.codebuild_environment_compute_type
    image           = var.codebuild_environment_image
    type            = var.codebuild_environment_type
    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.ecr_repo.name
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.code_build_source_buildspec
  }

  tags = {
    Environment = "Test-Enivronment"
  }
}

