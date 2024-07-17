resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(
    {
      "Name" = "${var.vpc_name}-rt-eip"
    },
    var.tags
  )
}
