resource "aws_instance" "nginx" {
  ami                         = "${lookup(var.ec2_amis, var.region)}"
  associate_public_ip_address = true
  count                       = 1
  depends_on                  = ["aws_lb.load-balancer"]
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.subnet.0.id}"
  user_data                   = "${file("nginx.sh")}"
  key_name                    = "test"
  vpc_security_group_ids = ["${aws_security_group.security-group.id}"]

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_instance" "apache" {
  ami                         = "${lookup(var.ec2_amis, var.region)}"
  associate_public_ip_address = true
  count                       = 1
  depends_on                  = ["aws_lb.load-balancer"]
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.subnet.1.id}"
  user_data                   = "${file("apache.sh")}"
  key_name                    = "test"

  # references security group created above
  vpc_security_group_ids = ["${aws_security_group.security-group.id}"]

  tags = {
    Name = "${var.solution_name}"
  }
}