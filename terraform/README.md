# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.67.0 |
| <a name="requirement_sops"></a> [sops](#requirement\_sops) | 0.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.67.0 |
| <a name="provider_sops"></a> [sops](#provider\_sops) | 0.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_delete_dynamodb_table"></a> [delete\_dynamodb\_table](#module\_delete\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | ~>3.1 |
| <a name="module_dynamo_eventbridge_rules"></a> [dynamo\_eventbridge\_rules](#module\_dynamo\_eventbridge\_rules) | terraform-aws-modules/eventbridge/aws | ~> 1.17.0 |
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | ~>3.1 |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | terraform-aws-modules/eventbridge/aws | ~> 1.17 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.allow_put_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_put_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.eventbridge_put_events_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [sops_file.teams](https://registry.terraform.io/providers/carlpett/sops/0.7.1/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name) | The name of the event bus to create in EventBridge | `string` | `"marias-bus"` | no |
| <a name="input_create_log_group"></a> [create\_log\_group](#input\_create\_log\_group) | If true, create a log group with appropriate permissions to write events from the bus | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
