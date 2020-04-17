artifact_store_type                = "S3"
github_token                       = ""
webhook_secret                     = "super-secret"
bucket_for_codepipeline            = "codepipeline-us-east-1-607240194735"
pipeline_name                      = "umar-tahir-terraform-codepipeline"
git_hub_owner                      = ""
repo_name                          = "springboot"
branch_name                        = "master"
source_stage_owner                 = "ThirdParty"
source_stage_provider              = "GitHub"
source_stage_output_artifact_name  = ["source_output"]
build_stage_output_artifact_name   = ["build_output"]
github_hook_name                   = "webhook-github-codepipeline"
aws_region                         = "us-east-1"
code_build_stage_project_name      = "umartahir-terraform-codebuild"
codebuild_stage_artifact           = "CODEPIPELINE"
codebuild_environment_compute_type = "BUILD_GENERAL1_SMALL"
codebuild_environment_image        = "aws/codebuild/standard:1.0"
codebuild_environment_type         = "LINUX_CONTAINER"
code_build_source_buildspec        = "buildspec.yml"