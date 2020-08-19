# vpc

resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
 #enable_dns_hostnames = true

  tags = {
    Name = "myvpc"

  }
}
#internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myvpc"
  }
}

#elastic ip address

resource "aws_eip" "eip" {
   vpc      = true
}

#nat

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.0.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "myvpc-natgateway"
  }
}

#routing table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "myvpc_public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "myvpc_private_rt"
  }
}

#subnets association

resource "aws_route_table_association" "a" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  count = length(var.private_subnet_cidr)
   subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

#dns

resource "aws_route53_record" "r" {
        zone_id = ""
        name = "www.example.com"
        type = "A"
      
	alias {
	name = aws_elb.elb.dns_name
	zone_id = aws_elb.elb.zone_id
	evaluate_target_health = true
	}
}

resource "aws_route53_record" "q" {
        zone_id = ""
        name = "example.com"
        type = "A"

        alias {
        name = aws_elb.elb.dns_name
        zone_id = aws_elb.elb.zone_id
        evaluate_target_health = true
        }
	allow_overwrite = true
}
output "aws_route53_record"{
	value = aws_route53_record.r.name
}
output "aws_route53_record1" {
	value = aws_route53_record.q.name
}

