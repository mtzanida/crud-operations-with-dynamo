# CRUD Operations with DynamoDB and AWS Lambda

This repository contains a CRUD API implemented with AWS Lambda and DynamoDB, alongside supporting infrastructure using Terraform for provisioning DynamoDB tables and EventBridge for handling events.

## Overview

This project includes:

- **Lambda functions** for handling CRUD operations on a DynamoDB table.
- **Terraform scripts** to set up the DynamoDB tables, EventBridge bus, and EventBridge rules for managing event flows.
- **EventBridge integration** to handle post-operation events triggered by DynamoDB.

## Table of Contents

- [Architecture](#architecture)
- [Setup](#setup)
- [Usage](#usage)
- [Lambda Function Endpoints](#lambda-function-endpoints)
- [Terraform Resources](#terraform-resources)
- [Requirements](#requirements)
- [Additional Information](#additional-information)

## Architecture

The API uses a single Lambda function to interact with a DynamoDB table. The following operations are available:

- **GET**: Retrieve data by `user_id`.
- **POST**: Insert a new entry.
- **PATCH**: Update an existing entry.
- **DELETE**: Remove an entry by `user_id`.

EventBridge is configured to listen for `POST` events from the Lambda function, sending notifications to specified targets.

## Setup

### Prerequisites

- AWS CLI configured with necessary permissions.
- Terraform installed.
- Python 3.9 for Lambda function dependencies.

### Lambda Setup

1. **Python Version**: Set to Python 3.9.10.
2. **Dependencies**: Install dependencies listed in `requirements.txt` and `requirements-dev.txt` as needed.
   ```bash
   pip install -r lambda/requirements.txt
   ```
3. **Deploy Lambda**: Configure and deploy the Lambda function to AWS.

### Terraform Infrastructure

1. **Initialize and Apply Terraform**:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```
   This sets up the DynamoDB tables, EventBridge bus, and IAM roles.

## Usage

Once deployed, you can interact with the API using HTTP requests to the Lambda function via API Gateway. Ensure proper IAM permissions for all operations.

### Lambda Function Endpoints

- **GET** `/dynamo?user_id=<value>`: Retrieves an item by `user_id`.
- **POST** `/dynamo`: Adds a new item. Provide JSON payload in the request body.
- **PATCH** `/dynamo`: Updates an item based on `user_id`, `updatedKey`, and `updatedValue`.
- **DELETE** `/dynamo?user_id=<value>`: Deletes an item by `user_id`.

### EventBridge Integration

EventBridge captures successful `POST` operations in DynamoDB and forwards the event to configured destinations. Rules and event buses are managed in the `terraform/dynamo_eventbridge_rules.tf` file.

## Terraform Resources

| File                          | Description                                               |
| ----------------------------- | --------------------------------------------------------- |
| `dynamo.tf`                   | Configures DynamoDB table resources.                      |
| `dynamo_eventbridge_rules.tf` | Sets up EventBridge rules for POST operation events.      |
| `eventbridge.tf`              | Configures the EventBridge bus and API destination rules. |
| `variables.tf`                | Defines customizable variables for the infrastructure.    |

## Requirements

- **AWS Lambda PowerTools**: Used for tracing and logging.
- **boto3**: AWS SDK for Python, required for DynamoDB interactions.
- **botocore**: Required for handling exceptions within AWS services.

## Additional Information

- **IAM Policy**: The `PutLambdaEventBridge` policy grants the Lambda permission to write to EventBridge.
- **Logging**: Lambda logging is managed through AWS Lambda Powertools.

## Contributing

To contribute, fork the repository and submit a pull request.
