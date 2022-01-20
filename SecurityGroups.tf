resource "aws_security_group" "SGS" {
  count = length(var.sg_names)
  name        = var.sg_names[count.index]
  description = var.sg_names[count.index]
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.sg_names[count.index]}"
  }

  dynamic "ingress" {
    for_each = var.sg_protocols[count.index]
    content {
      from_port = ingress.value["from_port"]
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "security-groups" {
  value = aws_security_group.SGS[*].id
}







# #Copy and paste resource for multiple security Groups

# resource "aws_security_group" "SGS" {
#   count = length(var.sg_names)
#   name        = var.sg_names[count.index]
#   description = var.sg_names[count.index]
#   vpc_id      = aws_vpc.vpc.id

#   #Copy and paste ingress block to add other rules
  
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.sg_names[count.index]}"
#   }
# }

# #Copy and paste Output block to have the SG id as an output

# output "security-groups" {
#   value = aws_security_group.SGS[*].id
# }