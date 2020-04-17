locals {
  subnets = {
    "${var.region}a" = "172.16.0.0/21"
    "${var.region}b" = "172.16.8.0/21"
    "${var.region}c" = "172.16.16.0/21"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_subnet" "subnet" {
  count      = "${length(local.subnets)}"
  cidr_block = "${element(values(local.subnets), count.index)}"
  vpc_id     = "${aws_vpc.vpc.id}"

  map_public_ip_on_launch = true
  availability_zone       = "${element(keys(local.subnets), count.index)}"

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.solution_name}"
  }
}

resource "aws_route" "route" {
  route_table_id         = "${aws_route_table.route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

resource "aws_route_table_association" "route-table-association" {
  count          = "${length(local.subnets)}"
  route_table_id = "${aws_route_table.route-table.id}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
}