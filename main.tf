data "aws_caller_identity" "current" {}

module "api" {
  source   = "./modules/api"
  api_name = var.api_name
}

module "lambda_add" {
  source                   = "./modules/lambda"
  myregion                 = var.myregion
  accountId                = data.aws_caller_identity.current.account_id
  name                     = var.add
  aws_api_gateway_rest_api = "${module.api.aws_api_gateway_rest_api}"
  api_gateway_method       = "${module.api_gateway_add.api_gateway_method}"
  aws_api_gateway_resource = "${module.api_gateway_add.aws_api_gateway_resource}"
  http_method                 = "PUT"
}
module "api_gateway_add" {
  source                      = "./modules/api-gateway"
  lambda                      = "${module.lambda_add.lambda_function}"
  aws_api_gateway_rest_api    = "${module.api.aws_api_gateway_rest_api}"
  resource                    = var.resource_add
  http_method                 = var.http_method_add
}
module "lambda_delete" {
  source                   = "./modules/lambda"
  myregion                 = var.myregion
  accountId                = data.aws_caller_identity.current.account_id
  name                     = var.delete
  aws_api_gateway_rest_api = "${module.api.aws_api_gateway_rest_api}"
  api_gateway_method       = "${module.api_gateway_delete.api_gateway_method}"
  aws_api_gateway_resource = "${module.api_gateway_delete.aws_api_gateway_resource}"
  http_method                 = "DELETE"
}
module "api_gateway_delete" {
  source                    = "./modules/api-gateway"
  lambda                    = "${module.lambda_delete.lambda_function}"
  aws_api_gateway_rest_api  = "${module.api.aws_api_gateway_rest_api}"
  resource                  = var.resource_delete
  http_method               = var.http_method_delete
}
module "lambda_update" {
  source                   = "./modules/lambda"
  myregion                 = var.myregion
  accountId                = data.aws_caller_identity.current.account_id
  name                     = var.update
  aws_api_gateway_rest_api = "${module.api.aws_api_gateway_rest_api}"
  api_gateway_method       = "${module.api_gateway_update.api_gateway_method}"
  aws_api_gateway_resource = "${module.api_gateway_update.aws_api_gateway_resource}"
  http_method                 = "PATCH"
}
module "api_gateway_update" {
  source                    = "./modules/api-gateway"
  lambda                    = "${module.lambda_update.lambda_function}"
  aws_api_gateway_rest_api  = "${module.api.aws_api_gateway_rest_api}"
  resource                  = var.resource_update
  http_method               = var.http_method_update
}
module "lambda_get" {
  source                   = "./modules/lambda"
  myregion                 = var.myregion
  accountId                = data.aws_caller_identity.current.account_id
  name                     = var.get
  aws_api_gateway_rest_api = "${module.api.aws_api_gateway_rest_api}"
  api_gateway_method       = "${module.api_gateway_get.api_gateway_method}"
  aws_api_gateway_resource = "${module.api_gateway_get.aws_api_gateway_resource}"
  http_method                 = "GET"
}
module "api_gateway_get" {
  source                      = "./modules/api-gateway"
  lambda                      = "${module.lambda_get.lambda_function}"
  aws_api_gateway_rest_api    = "${module.api.aws_api_gateway_rest_api}"
  resource                    = var.resource_get
  http_method                 = var.http_method_get
}
