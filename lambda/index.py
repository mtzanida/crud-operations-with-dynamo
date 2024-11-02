import json
import logging

import boto3
from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.logging import correlation_paths
from boto3.dynamodb.conditions import Attr, Key
from botocore.exceptions import ClientError

logger = Logger()

dynamodb = boto3.resource("dynamodb")
dynamoTableName = "dynamo-table"
table = dynamodb.Table(dynamoTableName)
tracer = Tracer()  # Sets service via POWERTOOLS_SERVICE_NAME env var
client = boto3.client("events")


@tracer.capture_lambda_handler
@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
def lambda_handler(event, context):
    httpMethod = event["httpMethod"]
    path = event.get("path", "/")
    if path == "/dynamo":
        if httpMethod == "GET":
            return getMethod(event["queryStringParameters"]["user_id"])
        elif httpMethod == "POST":
            return postMethod(json.loads(event["body"]))
        elif httpMethod == "PATCH":
            requestBody = json.loads(event["body"])
            return patchMethod(
                requestBody["user_id"],
                requestBody["updatedKey"],
                requestBody["updatedValue"],
            )
        elif httpMethod == "DELETE":
            return deleteMethod(event["queryStringParameters"]["user_id"])
        else:
            return buildResponse(404, "httpMethod not found!")
    else:
        return buildResponse(404, "path not found!")


@tracer.capture_method
def buildResponse(statusCode, body=None):
    response = {
        "statusCode": statusCode,
        # "headers": {
        #     "Content-Type": "application/json",
        #     "Access-Control-Allow-Origin": "*"
        # },
        # 2 check if this actually adds value?
    }
    if body:
        response["body"] = json.dumps(body)
    return response


@tracer.capture_method
def getMethod(user_id):
    key = {"user_id": user_id}
    # logger.info(json.dumps(key))
    response = table.get_item(Key=key)
    if "Item" in response:
        logger.info(json.dumps(response))
        return buildResponse(200, response["Item"])
    else:
        logger.info(json.dumps(response))
        return buildResponse(404, "user_id=%s not found " % user_id)


@tracer.capture_method
def postMethod(requestBody):
    response = table.put_item(Item=requestBody)
    body = {
        "operation": "POST",
        "message": "success",
        "posted value": requestBody,
        "PostedAttributes": response,
    }
    response = client.put_events(
        Entries=[
            {
                "Source": "dynamo",
                "DetailType": "dynamo_POST",
                "Detail": json.dumps(body),
                "EventBusName": "marias-bus",
            },
        ]
    )

    return buildResponse(200, body)


@tracer.capture_method
def patchMethod(user_id, updateKey, updatedValue):
    response = table.update_item(
        Key={"user_id": user_id},
        UpdateExpression="set %s = :value" % updateKey,
        ExpressionAttributeValues={":value": updatedValue},
        ReturnValues="UPDATED_NEW",
    )
    body = {"operation": "PATCH", "message": "success", "UpdatedAttributes": response}
    return buildResponse(200, body)


@tracer.capture_method
def deleteMethod(user_id):
    try:
        response = table.delete_item(Key={"user_id": user_id})
        body = {"operation": "DELETE", "message": "success", "deletedItem": response}
        return buildResponse(200, body)
    except ClientError as err:
        logger.error(
            "Couldn't delete entry with user_id: %s in table %s. Here's why: %s: %s",
            user_id,
            dynamoTableName,
            err.response["Error"]["Code"],
            err.response["Error"]["Message"],
        )
        raise
