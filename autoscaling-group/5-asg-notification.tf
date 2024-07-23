# resource "aws_autoscaling_notification" "this" {
#   count = length(var.notifications) > 0 ? 1 : 0

#   group_names = [aws_autoscaling_group.this.name]

#   notifications = var.notifications
#   topic_arn     = var.sns_topic_arn
# }
