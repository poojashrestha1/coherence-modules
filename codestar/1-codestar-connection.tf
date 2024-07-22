data "aws_codestarconnections_connection" "this" {
  name = var.codestarconnection_name

  tags = var.tags
}

# resource "aws_codestarconnections_host" "example" {
#   name              = "example-host"
#   provider_endpoint = "https://example.com"
#   provider_type     = "GitHubEnterpriseServer"
# }
