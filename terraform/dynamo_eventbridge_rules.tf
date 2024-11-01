module "dynamo_eventbridge_rules" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "~> 1.17.0"

  bus_name    = var.bus_name
  create_bus  = false
  create_role = false

  depends_on = [
    module.eventbridge
  ]

  rules = {
    found_post_operation = {
      description = "Detected POST operation on dynamo db"
      event_pattern = jsonencode({
        "source" = ["mdlz.dynamo"]
        "detail" = {
          "operation" = ["POST"],
          "message"   = ["success"]
        }
      })
    }
  }

  targets = {
    found_post_operation = [
      {
        name            = "dynamoDbPostNotifications"
        arn             = module.eventbridge.eventbxridge_api_destination_arns["teams_testing"]
        attach_role_arn = module.eventbridge.eventbridge_role_arn
        input_transformer = {
          input_paths = {
            payload = "$.detail.data"
          }
          input_template = file("../templates/post_operation.json")
        }
      }
    ]
  }
}
