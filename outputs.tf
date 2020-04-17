output "url" {
  value = "http://${aws_lb.load-balancer.dns_name}/"
}