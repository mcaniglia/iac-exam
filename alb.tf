data "aws_subnet_ids" "subnet-ids" {
  vpc_id = "${aws_vpc.vpc.id}"

  depends_on = ["aws_subnet.subnet"]
}

resource "aws_security_group" "security-group" {
  name   = "allow-http"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_lb" "load-balancer" {
  name               = "${var.solution_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.security-group.id}"]
  subnets            = data.aws_subnet_ids.subnet-ids.ids

  depends_on = ["aws_subnet.subnet"]

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_lb_target_group" "target-group" {
  count = "2"

  name = "${var.solution_name}-targetgroup"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc.id}"

  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "attachment-nginx" {
  target_group_arn = "${aws_lb_target_group.target-group.0.arn}"
  target_id        = "${aws_instance.nginx.0.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment-apache" {
  target_group_arn = "${aws_lb_target_group.target-group.1.arn}"
  target_id        = "${aws_instance.apache.0.id}"
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_lb.load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target-group.*.arn[0]}"
  }
}

resource "aws_lb_listener_rule" "listener-rule" {
  listener_arn = "${aws_lb_listener.listener.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target-group.*.arn[0]}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}