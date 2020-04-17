#Code Pipeline
resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.bucket_for_codepipeline
    type     = var.artifact_store_type
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = var.source_stage_owner
      provider         = var.source_stage_provider
      version          = "1"
      output_artifacts = var.source_stage_output_artifact_name

      configuration = {
        OAuthToken           = var.github_token
        Owner                = var.git_hub_owner
        Repo                 = var.repo_name
        Branch               = var.branch_name
        PollForSourceChanges = var.poll_source_changes
      }
    }
  }



  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = var.source_stage_output_artifact_name
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_build_stage_pipeline.name
      }
    }
  }
}