# AMI

resource "aws_instance" "this" {
  count = var.create_instance ? 1 : 0

  ami           = var.ami
  instance_type = var.instance_type

  user_data = var.user_data

  availability_zone = var.availability_zone
  subnet_id         = var.subnet_id
  # vpc_security_group_ids = aws_security_group.my_sg.id

  key_name = var.key_name



  tags = merge({ "Name" = var.name }, var.instance_tags, var.tags)
}

# resource "aws_security_group" "my_sg" {
#   name   = "my-security-group"
#   vpc_id = "vpc-0566dd4d3caf7b8f3"

# }
