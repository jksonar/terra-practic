resource "aws_launch_template" "launch_temp" {
  name = "my-launch-template"

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 8
    }
  }

  image_id = data.aws_ami.ubuntu.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  key_name = "terra-key"

}

resource "aws_autoscaling_group" "my_auto_scale" {
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  name               = "my-auto-scaling-terraform"
  desired_capacity   = 1
  max_size           = 5
  min_size           = 1
  launch_template {
    id      = aws_launch_template.launch_temp.id
    version = "$Latest"
  }
}
