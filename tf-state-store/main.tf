provider "aws" {
  profile = "codelabs"
  region  = "eu-north-1"
}

resource "aws_s3_bucket" "state" {
  bucket = "mattias-tf-state"
  policy = "${data.aws_iam_policy_document.iam_policy_document_s3.json}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "state_lock" {
  name           = "mattias-tf-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

data "aws_iam_policy_document" "iam_policy_document_s3" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::mattias-tf-state"]

    principals {
      type        = "AWS"
      identifiers = ["106618949447"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::mattias-tf-state/*"]

    principals {
      type        = "AWS"
      identifiers = ["106618949447"]
    }
  }
}

data "aws_iam_policy_document" "iam_policy_document_dynamodb" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:eu-north-1:106618949447:table:mattias-tf-lock"]

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]

    principals {
      type        = "AWS"
      identifiers = ["106618949447"]
    }
  }
}
