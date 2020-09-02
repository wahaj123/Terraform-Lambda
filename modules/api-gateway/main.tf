resource "aws_api_gateway_resource" "resource" {
  path_part   = var.resource
  parent_id   = var.aws_api_gateway_rest_api.root_resource_id
  rest_api_id = var.aws_api_gateway_rest_api.id
}

resource "aws_api_gateway_method" "method" {
  count         = "${var.http_method != "GET" ? 1 : 0}"
  rest_api_id   = var.aws_api_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integration" {
  count         = "${var.http_method != "GET" ? 1 : 0}"
  rest_api_id             = var.aws_api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.lambda.invoke_arn
}
resource "aws_api_gateway_method_response" "response" {
  count         = "${var.http_method != "GET" ? 1 : 0}"
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method[count.index].http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}
resource "aws_api_gateway_integration_response" "response_method_integration" {
  count       = "${var.http_method != "GET" ? 1 : 0}"
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method_response.response[count.index].http_method
  status_code = aws_api_gateway_method_response.response[count.index].status_code
  depends_on = [
    aws_api_gateway_integration.integration
  ]
}

###############################GET_METHOD######################################
resource "aws_api_gateway_integration" "getIntegration" {
  count                   = "${var.http_method == "GET" ? 1 : 0}"
  rest_api_id             = var.aws_api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method_get[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.lambda.invoke_arn
  request_templates       = {

      "application/json"  = <<REQUEST_TEMPLATE
    { 
      "employee_id": "$input.params('employee_id')"
    }
  REQUEST_TEMPLATE
  }
}

resource "aws_api_gateway_method" "method_get" {
  count         = "${var.http_method == "GET" ? 1 : 0}"
  rest_api_id   = var.aws_api_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.employee_id" = true
  }
}

resource "aws_api_gateway_method_response" "response_get" {
  count       = "${var.http_method == "GET" ? 1 : 0}"
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method_get[count.index].http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}
resource "aws_api_gateway_integration_response" "response_method_integration_get" {
  count       = "${var.http_method == "GET" ? 1 : 0}"
  rest_api_id = var.aws_api_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method_response.response_get[count.index].http_method
  status_code = aws_api_gateway_method_response.response_get[count.index].status_code
  depends_on = [
    aws_api_gateway_integration.getIntegration
  ]
}


