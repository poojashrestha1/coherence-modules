resource "aws_autoscaling_traffic_source_attachment" "this" {
  count = var.create_traffic_source_attachment ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.this.id

  traffic_source {
    identifier = var.traffic_source_identifier
    type       = var.traffic_source_type
  }
}
