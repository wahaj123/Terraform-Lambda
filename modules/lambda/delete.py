import json
import boto3
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Employee-wahaj')

def lambda_handler(event, context):
    employee_id = event['employee_id']
    try:    
        delete = table.delete_item(
        Key={
            'employee_id': employee_id
        }
        )
        return {
                'statusCode': 200,
                'body': json.dumps('Succesfully deleted employee!')
            }
    except:
        print('Closing lambda function')
        return {
                'statusCode': 400,
                'body': json.dumps('Error deleting the employee')
        }
