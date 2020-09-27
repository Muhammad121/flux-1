
resource "aws_launch_configuration" "webcluster" {
  image_id = "ami-0596aab74a1ce3983"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
lifecycle {
  create_before_destroy = true
}
  }


resource "aws_autoscaling_group" "webcluster" {
 launch_configuration = aws_launch_configuration.webcluster.name
 availability_zones = data.aws_availability_zones.all.names

 min_size = 2
 max_size = 10

 tag {
   key = "Name"
   value = "asg-webcluster"
   propagate_at_launch = true
 }
}

resource "aws_security_group" "instance" {
  name = "Webcluster-SG"

  ingress {
   from_port = var.server_port
   to_port = var.server_port
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
}
