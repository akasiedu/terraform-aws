resource "aws_s3_bucket" "tform-ak-backend" {
  bucket = format("%s-%s-%s-state", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
  acl    = "private"
  provider = aws.state  # Using the correct provider alias

  versioning {
    enabled = true
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-%s-state", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
  })

  replication_configuration {
    role = aws_iam_role.s3_replication_role.arn

    rules {
      id     = "StateReplicationAll"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.replica_bucket.arn
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_s3_bucket" "replica_bucket" {
  bucket = "replica-terraform-state-bucket"
  acl    = "private"
  provider = aws.backup  # Ensure correct provider alias for the backup region

  versioning {
    enabled = true
  }

  tags = merge(var.common_tags, {
    Name = "Replica Bucket for Terraform State"
  })
}

resource "aws_iam_role" "s3_replication_role" {
  name     = "s3-replication-role"
  provider = aws.state  # Correct alias for IAM role in source region

  assume_role_policy = <<POLICY
  {
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "s3.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  }
POLICY
}

resource "aws_iam_policy" "replication" {
  name     = "tf-state-backend-policy"
  provider = aws.state  # Correct alias for the IAM policy provider

  policy = <<POLICY
  {
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "s3:GetReplicationConfiguration",
            "s3:ListBucket"
         ],
         "Resource": [
            "${aws_s3_bucket.tform-ak-backend.arn}"
         ]
      },
      {
         "Effect": "Allow",
         "Action": [
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging"
         ],
         "Resource": [
            "${aws_s3_bucket.tform-ak-backend.arn}/*"
         ]
      },
      {
         "Effect": "Allow",
         "Action": [
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags"
         ],
         "Resource": "${aws_s3_bucket.replica_bucket.arn}/*"
      }
   ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  role       = aws_iam_role.s3_replication_role.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_dynamodb_table" "terraform-state-lock" {
  provider = aws.state
  name          = format("%s-%s-%s-state-lock", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"])
  hash_key      = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
