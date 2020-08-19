#aws subnets

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_subnet_cidr,count.index)
  availability_zone       = element(var.azs,count.index)

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id                = aws_vpc.myvpc.id
  cidr_block            = element(var.private_subnet_cidr,count.index)
  availability_zone     = element(var.azs,count.index)

  tags = {
    Name = "private"
  }
  
}




