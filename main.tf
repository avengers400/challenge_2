provider "aws" {
    region = "us-east-2"
    secret_key = "xxxxxD6lzKIJ0R"
    access_key = "xxxxxJMR7PO"
}

variable "ec2names" {
    description = "tags of ec2"
    type = list(string)
    default = ["testec2", "demoec2"]
  
}

resource "aws_instance" "ec2" {
    instance_type = "t2.micro"
    count = length(var.ec2names)
    security_groups = [aws_security_group.sg_group.name]
    ami = "ami-07251f912d2a831a3"
    tags = {
        Name = var.ec2names[count.index]
    }
}



resource "aws_security_group" "sg_group" {
    name = "Allow SSH and HTTP"
    ingress{
     from_port = 22
     to_port = 22
     protocol = "TCP"
     cidr_blocks = ["0.0.0.0/0"]
  }
    ingress{
     from_port = 80
     to_port = 80
     protocol = "TCP"
     cidr_blocks = ["0.0.0.0/0"]
  }

  
}

data "aws_instance" "outputvalues" {
    filter {
        name = "tag:Name"
        values = ["testec2"]
    }
    depends_on = [
        aws_instance.ec2
    ]
}

output "info_of_aws_instance" {
    value = data.aws_instance.outputvalues
  
}


   
