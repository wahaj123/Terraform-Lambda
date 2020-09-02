#data
data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/${var.name}.py"
  output_path = "${path.module}/${var.name}.zip"
}
# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  lifecycle {
    create_before_destroy = true
  }
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${var.aws_api_gateway_rest_api.id}/*/${var.http_method}${var.aws_api_gateway_resource.path}"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.name
  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  role             = aws_iam_role.role.arn
  handler          = "${var.name}.lambda_handler"
  runtime          = "python3.7"
  lifecycle {
    create_before_destroy = true
  }
}

# IAM
resource "aws_iam_role" "role" {
  name = "myrole_${var.name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.role.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}