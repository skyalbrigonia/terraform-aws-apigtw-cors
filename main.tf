# cors handling

resource "aws_api_gateway_method" "cors" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors" {
  depends_on          = [
    aws_api_gateway_method.cors
  ]  
  rest_api_id          = var.rest_api_id
  resource_id          = var.resource_id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "cors" {
  depends_on          = [
    aws_api_gateway_method.cors
  ]
  rest_api_id         = var.rest_api_id
  resource_id         = var.resource_id
  http_method         = aws_api_gateway_method.cors.http_method
  status_code         = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models     = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "cors" {
  depends_on          = [
    aws_api_gateway_integration.cors,
    aws_api_gateway_method_response.cors
  ]
  rest_api_id         = var.rest_api_id
  resource_id         = var.resource_id
  http_method         = aws_api_gateway_method.cors.http_method
  status_code         = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type, X-Amz-Date, Authorization, X-Api-Key, X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'"
  }
}
