output "launch_template_id" {
  value = aws_launch_template.my_template.id
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.my_asg.id
}