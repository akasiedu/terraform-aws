source "amazon-ebs" "ubuntu" {
  ami_name                    = "s4-bastion"
  ami_description             = "The is the AMI to launch the bastion host"
  instance_type               = "t3.medium"
  region                      = "us-east-1"
  # If we do not specify the VPC, Packer will use the default VPC
  # vpc_id                      = "vpc-068852590ea4b093b"
  # subnet_id                   = "subnet-096d45c28d9fb4c14"
  # source_ami                  = "ami-007855ac798b5175e"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/*ubuntu-*${var.release}-amd64-server*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username              = "ubuntu"

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = "30"
    volume_type           = "gp2"
  }

  tags = {
    "Name"        = "jenkins-node-bastion"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

build {
  name = "jenkins-node-bastion"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "file" {
    source      = "C:/Users/there/OneDrive/Desktop/Learning Devops/terraform/terraform-aws/EC2/packer/jenkins-bashion.sh"  
    destination = "/tmp/bastion.sh"
  }
  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/bastion.sh",
      "sudo bash /tmp/bastion.sh"
    ]
  }
}
