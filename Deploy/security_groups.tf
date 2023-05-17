locals {
  sg = { for sg in var.securityGroups : sg.name => sg }
  sgRules = { for rule in flatten([
    for group in var.securityGroups : [
      for rule in group.rules : merge({ sg = group.name }, rule)
    ]
  ]) : "${rule.sg}_${rule.type}_${rule.target}_${local.portMapping[rule.fromPort]}_${local.portMapping[rule.toPort]}" => rule }
}

resource "aws_security_group" "sg" {
  for_each    = local.sg
  name        = "${var.project}-${each.value.name}"
  description = each.value.description
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${each.value.name}"
  }
}

resource "aws_security_group_rule" "sg-rules" {
  for_each                 = local.sgRules
  security_group_id        = aws_security_group.sg[each.value.sg].id
  type                     = each.value.type
  description              = each.value.description
  from_port                = local.portMapping[each.value.fromPort]
  to_port                  = local.portMapping[each.value.toPort]
  protocol                 = each.value.protocol
  cidr_blocks              = substr(each.value.target, 0, 3) != "sg-" ? var.sgData[each.value.target] : null
  source_security_group_id = substr(each.value.target, 0, 3) == "sg-" ? aws_security_group.sg[substr(each.value.target, 3, length(each.value.target) - 3)].id : null
}
