resource "aws_codebuild_project" "code_build_stage_pipeline" {
  name         = var.code_build_stage_project_name
  service_role = aws_iam_role.example.arn

  artifacts {
    type = var.codebuild_stage_artifact #ASK
  }

  environment {
    compute_type = var.codebuild_environment_compute_type
    image        = var.codebuild_environment_image
    type         = var.codebuild_environment_type

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
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