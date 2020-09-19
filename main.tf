
resource "aws_instance" "web" {
  ami           = "ami-0596aab74a1ce3983"
  instance_type = "t2.micro"

  tags = {
    Name = "Flux-web-server"
  }
}
