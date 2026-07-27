resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
  "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/example-abc"   = "shared"
}
}
resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
  "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/example-abc"   = "shared"
}
}
resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
  "kubernetes.io/role/internal-elb" = "1"
  "kubernetes.io/cluster/example-abc"   = "shared"
}
}
resource "aws_subnet" "main4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
  "kubernetes.io/role/internal-elb" = "1"
  "kubernetes.io/cluster/example-abc"   = "shared"
}
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc" 

  tags = {
    Name = "nat-gateway-eip"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main1.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_route_table" "art" {
  vpc_id = aws_vpc.main.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table" "art1" {
  vpc_id = aws_vpc.main.id
   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table" "art2" {
  vpc_id = aws_vpc.main.id
   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "arta1" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.art.id
}
resource "aws_route_table_association" "arta2" {
  subnet_id      = aws_subnet.main1.id
  route_table_id = aws_route_table.art.id
}
resource "aws_route_table_association" "arta3" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.art1.id
}
resource "aws_route_table_association" "arta4" {
  subnet_id      = aws_subnet.main4.id
  route_table_id = aws_route_table.art2.id
}
