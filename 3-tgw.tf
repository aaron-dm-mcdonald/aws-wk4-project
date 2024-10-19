resource "aws_ec2_transit_gateway" "tgw" {
  description = var.tgw_name
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc1.id
  subnet_ids         = [aws_subnet.public_subnet.id]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc2.id
  subnet_ids         = [aws_subnet.private_subnet.id]
}
