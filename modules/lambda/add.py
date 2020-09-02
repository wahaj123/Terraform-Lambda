import boto3
from pprint import pprint
import json
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Employee-wahaj')

def lambda_handler(event, context):
    try:
        id=uuid.uuid1() 
        employee_id = str(id)
        first_name = event ['first_name']
        last_name = event ['last_name']
        table.put_item(
          Item={
                'first_name': first_name,
                'last_name': last_name,
                'employee_id' : employee_id
            }
        )
        return {
            'statusCode': 200,
            'body': json.dumps('Succesfully inserted employee!'),
            'employee_id': employee_id
        }
    except:
        print('Closing lambda function')
        return {
                'statusCode': 400,
                'body': json.dumps('Error saving the employee'),
        }
    