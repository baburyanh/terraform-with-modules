data "template_file" "user_data" {
  template = file(var.user_data_script_path)
}

resource "aws_launch_template" "my_template" {
  name          = "my-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
  }

  key_name                             = var.key_name
  instance_initiated_shutdown_behavior = "terminate"
  ebs_optimized                        = true

  network_interfaces {
    security_groups             = [var.security_group_id]
    associate_public_ip_address = var.associate_public_ip_address
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name = "my-asg"
  launch_template {
    id      = aws_launch_template.my_template.id
    version = aws_launch_template.my_template.latest_version
  }
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.public_subnet_ids

  tag {
    key                 = "Name"
    value               = "terraform-instance"
    propagate_at_launch = true
  }

  target_group_arns = var.target_group_arns
}