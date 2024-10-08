resource "aws_instance" "ec2-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = ""
  subnet_id = ""
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
