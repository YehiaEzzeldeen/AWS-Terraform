resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id =  aws_vpc.vpc.id
}

resource "aws_customer_gateway" "customer_gateway" {
  count = length(var.Customer_gateway_ip)
  bgp_asn    = 65000
  ip_address = var.Customer_gateway_ip[count.index]
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
  count = length(var.vpn_connection_names)
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway[count.index].id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "${var.vpn_connection_names[count.index]}"
  }
}

resource "aws_vpn_connection_route" "route" {
  count = length(var.vpn_connection_names)
  destination_cidr_block = var.vpn_connection_routes_CIDR[count.index]
  vpn_connection_id      = aws_vpn_connection.main[count.index].id
}

resource "aws_vpn_gateway_route_propagation" "pub_propagation" {
  count = length(var.public_subnets)
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_vpn_gateway_route_propagation" "prv_propagation" {
  count = length(var.private_subnets)
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = aws_route_table.prv_rt.id
}