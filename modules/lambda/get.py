
import boto3
from pprint import pprint
import json
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Employee-wahaj')

def lambda_handler(event, context):
    employee_id = event['employee_id']
    try:    
        response = table.get_item(
            Key={
                'employee_id': employee_id
            }
        )
        return response['Item']
    except:
        print('Closing lambda function')
        return {
                'statusCode': 400,
                'body': json.dumps('Error finding the employee')
        }    