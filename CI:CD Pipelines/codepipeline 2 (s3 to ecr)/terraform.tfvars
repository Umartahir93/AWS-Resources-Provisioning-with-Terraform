#General
aws_region = "us-east-1"


#Code Pipeline Variables
pipeline_name           = "umar-tahir-terraform-codepipeline-ecr"
bucket_for_codepipeline = "codepipeline-us-east-1-607240194735"
artifact_store_type     = "S3"


#Source stage variables
source_stage_owner                = "ThirdParty"
source_stage_provider             = "GitHub"
source_stage_output_artifact_name = ["source_output"]
github_token                      = ""
git_hub_owner                     = ""
repo_name                         = "s3-ecr-pipeline"
branch_name                       = "master"
poll_source_changes               = true


#Code Build stage variables
build_stage_output_artifact_name   = ["build_output"]
code_build_stage_project_name      = "umartahir-terraform-codebuild-ecr-build-stage"
codebuild_stage_artifact           = "CODEPIPELINE"
codebuild_environment_compute_type = "BUILD_GENERAL1_SMALL"
codebuild_environment_image        = "aws/codebuild/standard:1.0"
codebuild_environment_type         = "LINUX_CONTAINER"
code_build_source_buildspec        = "buildspec.yml"

