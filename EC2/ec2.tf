resource "aws_instance" "ec2-instance" {
  ami = "ami-0b9b8c2d5084f0e09"
  instance_type = "t2.micro"
  key_name = "terraform-key"
  subnet_id = "subnet-03e33261c7f2f5d56"
  vpc_security_group_ids = [aws_security_group.example.id]
  
  tags = merge(var.common_tags, {
   Name = format("%s-%s-%s-bashion-host", var.common_tags["AssetID"], var.common_tags["Environment"], var.common_tags["Project"]) 
})
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 10
    volume_type = "gp2"
  }
}