provider "aws" {
  profile = "codelabs"
  region  = "eu-north-1"
}

provider "aws" {
  profile = "codelabs"
  region  = "eu-north-1"
  alias   = "sthlm"
}

provider "aws" {
  profile = "codelabs"
  region  = "eu-central-1"
  alias   = "ff"
}

module "sthlm-instance" {
  source = "./instance-mod"
  providers = {
    aws = aws.sthlm
  }
}

# module "ff-instance" {
#   source = "./instance-mod"
#   providers = {
#     aws = aws.ff
#   }
# }

terraform {
  backend "s3" {
    bucket         = "mattias-tf-state"
    key            = "tf-state"
    region         = "eu-north-1"
    dynamodb_table = "mattias-tf-lock"
    profile        = "codelabs"
  }
}
