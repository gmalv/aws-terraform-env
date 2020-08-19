resource "aws_launch_configuration" "mypc_conf" {
 	 name_prefix   = "mypc_conf"
  	image_id      = var.ami
  	instance_type = "t2.micro"
  	key_name = aws_key_pair.ec2key.key_name
  	security_groups = [aws_security_group.myvpc_sg.id]
  	user_data = file("httpd.sh")
  	
	root_block_device {
		delete_on_termination = true
	}	

  	lifecycle {
    		create_before_destroy = true
  	}

  }

resource "aws_autoscaling_group" "myvpc_autoscaling" {
  	name                      = "myvpc_autoscaling"
  	max_size                  = 4
  	min_size                  = 2
 	#desired_capacity          = 2
 
	lifecycle {
    		create_before_destroy = true
  }
 	health_check_grace_period = 300
  	health_check_type         = "ELB"
  	force_delete              = true
  	launch_configuration      = aws_launch_configuration.mypc_conf.name
  	vpc_zone_identifier       = aws_subnet.public.*.id
  	load_balancers            = [aws_elb.elb.name]
}

	output "elb_dns_name" {
		value = aws_elb.elb.dns_name
		description = "the domain name of the clb"
	}


resource "aws_instance" "db" {
	count = length(var.private_subnet_cidr)
	ami = var.ami
  	instance_type = "t2.micro"
	associate_public_ip_address = "false"
	subnet_id = element(aws_subnet.private.*.id, count.index)
	vpc_security_group_ids = ["${aws_security_group.nat_gw.id}"]
	#key_name = aws_key_pair.ec2key.key_name
	depends_on = [aws_nat_gateway.natgw]
	
	root_block_device {
	
		delete_on_termination = true

	}
}

	
