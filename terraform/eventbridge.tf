module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "~> 1.17"
  tags = {
    Name = "eventbridge"
  }
  bus_name                 = var.bus_name
  attach_cloudwatch_policy = var.create_log_group
  cloudwatch_target_arns   = var.create_log_group ? [module.event_bus_logs.cloudwatch_log_group_arn] : []
  connections = { for name in nonsensitive(keys(yamldecode(data.sops_file.teams.raw)["url"])) :
    "teams_${name}" => {
      authorization_type = "API_KEY"
      auth_parameters = {
        api_key = {
          key   = "disregard"
          value = "disregard"
        }
      }
    }
  }

  api_destinations = {
    for name, url in nonsensitive(yamldecode(data.sops_file.teams.raw)["url"]) :
    "teams_${name}" => {
      description                      = "${name} channel"
      invocation_endpoint              = url
      http_method                      = "POST"
      invocation_rate_limit_per_second = 20
    }
  }
  create_archives               = false
  create_schemas_discoverer     = false
  attach_api_destination_policy = true
  create_api_destinations       = true
  create_connections            = true
}



resource "aws_iam_policy" "allow_put_events" {
  name        = "PutLambdaEventBridge"
  description = "A policy to allow  Lambdas to post events to Eventbridge"
  policy      = data.aws_iam_policy_document.eventbridge_put_events_policy.json
}
resource "aws_iam_role_policy_attachment" "lambda_put_events" {
  role       = module.dynamo-lambda.lambda_role_name
  policy_arn = aws_iam_policy.allow_put_events.arn
}

data "aws_iam_policy_document" "eventbridge_put_events_policy" {
  statement {
    sid       = "AllowEventbridge"
    actions   = ["events:PutEvents"]
    resources = [module.eventbridge.eventbridge_bus_arn]
  }
}


data "sops_file" "teams" {
  source_file = "../teams.secrets.yaml" //not here for obvious reasons
}
