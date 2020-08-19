resource "aws_security_group" "myvpc_sg" {
  name        = "myvpc-sg"
  description = "Allow ssh/http/https traffic"
  vpc_id      = aws_vpc.myvpc.id
                
 	ingress {
    	description = "http"
    	from_port   = 80
    	to_port     = 80
    	protocol    = "tcp"
    	cidr_blocks = ["0.0.0.0/0"]
  }

 	 ingress {
	
	description = "https"
	from_port = 443
	to_port =443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}

	ingress { 
	
	description = "ssh"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
  
	egress {
    	
	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myvpc-sg"
  }
}

resource "aws_security_group" "nat_gw" {
	name = "nat_gw"
	description = "sg for nat"
	vpc_id = aws_vpc.myvpc.id

	ingress { 
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	egress {
	from_port = 0
	to_port =0 
	protocol = "-1" 
	cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "lb_sg" {
	description = "security group for load balancer"
	vpc_id =aws_vpc.myvpc.id
	 
	ingress {
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	}
}
