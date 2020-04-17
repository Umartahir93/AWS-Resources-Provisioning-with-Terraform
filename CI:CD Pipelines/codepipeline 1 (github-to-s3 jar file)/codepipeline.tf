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
        PollForSourceChanges = true
        OAuthToken           = var.github_token
        Owner                = var.git_hub_owner
        Repo                 = var.repo_name
        Branch               = var.branch_name
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

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = "umartahir-terraform-buckettestus-east-1"
        Extract    = true
      }
    }
  }


}







# See this in detail later

# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.

# locals {
#   webhook_secret = "super-secret"
# }

# resource "aws_codepipeline_webhook" "github_hook" {
#   name            = var.github_hook_name
#   authentication  = "GITHUB_HMAC"
#   target_action   = "Source"
#   target_pipeline = aws_codepipeline.codepipeline.name


#   authentication_configuration {
#     secret_token = "${local.webhook_secret}"
#   }

#   filter {
#     json_path    = "$.ref"
#     match_equals = "refs/heads/{Branch}" #see this later
#   }
# }


# # See this in detail later
# # Wire the CodePipeline webhook into a GitHub repository.
# resource "github_repository_webhook" "web_hook_github" {
#   repository = var.repo_name
#   configuration {
#     url          = aws_codepipeline_webhook.github_hook.url
#     content_type = "json"
#     insecure_ssl = true
#     secret       = local.webhook_secret
#   }
#   events = ["push"]
# }
