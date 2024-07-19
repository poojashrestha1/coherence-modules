# resource "aws_dynamodb_table_item" "this" {
#   count = length(var.seed_file) > 0 ? 1 : 0

#   table_name = aws_dynamodb_table.this.name
#   hash_key   = aws_dynamodb_table.this.hash_key

#   item = data.template_file.seed_item.rendered
# }
