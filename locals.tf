locals {
  lambda_function_name_api = "${var.env}-${var.lambda_function_name}-api"
  lambda_role_api             = "${var.env}-${var.lambda_role}-api"
  lambda_policy_name       = "${var.env}-${var.lambda_policy_name}"
  api_name                 = "${var.env}-${var.api_name}"
  stage_name               = "${var.env}-${var.stage_name}"
  dynamodb_table_name      = "${var.env}-${var.dynamodb_table_name}"
  name_authorizer          = "${var.env}-${var.name_authorizer}"
  lambda_function_name_sqs = "${var.env}-${var.lambda_function_name}-sqs"
  lambda_policy_name_sqs   = "${var.env}-${var.lambda_policy_name}-sqs"
  lambda_role_sqs          = "${var.env}-${var.lambda_role}-sqs"
  dl_sqs = "${var.env}-events-sqs"
}