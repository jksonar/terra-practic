output "aws_ec2_ip" {
  value = aws_instance.web.public_ip
}
output "aws_ec2_id" {
  value = aws_instance.web.id
}
