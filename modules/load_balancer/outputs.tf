output "load_balancer_arn" {
  value = aws_lb.my_alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.my_target_group.arn
}