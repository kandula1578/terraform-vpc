resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "public-us-east-2a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "public-us-east-2b"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "private-us-east-2a"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private-us-east-2b"
  }
}
