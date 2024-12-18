module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~>3.1"

  name     = "dynamo-table"
  hash_key = "user_id"
  # range_key           = "email"


  attributes = [
    {
      name = "user_id"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "DEV"
    app-name    = "AWS Platform"
    stage       = "dev"
  }
}


module "delete_dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~>3.1"

  name     = "delete-dynamo-table"
  hash_key = "user_id"
  # range_key           = "email"


  attributes = [
    {
      name = "user_id"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "DEV"
    app-name    = "AWS Platform"
    stage       = "dev"
  }

}
