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

resource "cloudamqp_instance" "rmq_bunny" {
  name        = "mattias-terraform"
  plan        = "lemur"
  region      = "amazon-web-services::eu-north-1"
  rmq_version = "3.7.18"
  tags        = ["demo"]
}

# module "sthlm-instance" {
#   source = "./instance-mod"
#   providers = {
#     aws = aws.sthlm
#   }
# }

# module "ff-instance" {
#   source = "./instance-mod"
#   providers = {
#     aws = aws.ff
#   }
# }
