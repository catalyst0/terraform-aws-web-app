# Application Layer
# ///////////////
# Launch Template
resource "aws_launch_template" "launch_template" {
  name = "application"
  iam_instance_profile {
    name = var.ec2_profile["s3read"].name
  }
  image_id               = var.inst_params["ami"]["application"]
  instance_type          = var.inst_params["type"]["application"]
  key_name               = var.inst_params["key_name"]["application"]
  vpc_security_group_ids = [var.security_group["application"].id]
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
  # User Data for Amazon Linux OS
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
echo 'sudo aws s3 sync s3://${var.s3_bucket_source} /var/www/html' > /home/ec2-user/sync.sh
chmod +x /home/ec2-user/sync.sh
echo '* * * * * /home/ec2-user/sync.sh >/dev/null 2>&1' | crontab
cd /var/www/html
aws s3 sync s3://${var.s3_bucket_source} . 
EOF
  )
}
# /////////////////
# AutoScaling Group
resource "aws_autoscaling_group" "asg_application" {
  name                = "application"
  max_size            = var.asg_params["max_size"]
  min_size            = var.asg_params["min_size"]
  desired_capacity    = var.asg_params["desired_capacity"]
  vpc_zone_identifier = [for subnet in var.subnets_list["private"] : subnet.id]
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.lb_http_target.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

}
# /////////////
# Load Balancer
resource "aws_lb" "app_lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group["load_balancer"].id]
  subnets            = [for subnet in var.subnets_list["public"] : subnet.id]
  tags               = var.tags
}
# ////////////
# HTTP traffic
resource "aws_lb_target_group" "lb_http_target" {
  name        = "http-target"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "http_listner" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_http_target.arn
  }
}