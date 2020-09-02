import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Employee-wahaj')

update_expression_values = []
expression_attribute_values = {}



def lambda_handler(event, context):
    
    global update_expression_values
    global expression_attribute_values
    
    update_expression_values = []
    expression_attribute_values = {}
    employee_id = event['employee_id']
    
    if 'employee_id' in event:
        employee_id = event['employee_id']
    else:
        raise ValueError("employee_id not given")
            
    for key in event:
        
        if key != 'employee_id':
              if key in event:
                print (key)
                update_expression_values.append(key + ' = :val_' + key)
                print(update_expression_values)
                expression_attribute_values[':val_' + key] = event[key]
                print (expression_attribute_values)
          #process_event_key(event, values)
          
        else:
           print('skiping')

    if len(update_expression_values) < 1:
        raise ValueError("first_name and last_name not given")

    seperator = ','
        
    update = table.update_item(
        Key={
                'employee_id': employee_id
            },
        ConditionExpression= 'attribute_exists(employee_id)',
        UpdateExpression='SET ' + seperator.join(update_expression_values),
        ExpressionAttributeValues=expression_attribute_values,
        ReturnValues="UPDATED_NEW"
    )
    return {
        'statusCode': 200,
        'body': json.dumps('Succesfully inserted employee!')
    }
    # except:
    #     print('Closing lambda function')
    #     return {
    #             'statusCode': 400,
    #             'body': json.dumps('Error saving the employee')
    #     }

    
# def process_event_key(event, key):
#     global update_expression_values
#     global expression_attribute_values
    
#     if key in event:
#         print (key)
#         update_expression_values.append(key + ' = :val_' + key)
#         print(update_expression_values)
#         expression_attribute_values[':val_' + key] = event[key]
#         print (expression_attribute_values)