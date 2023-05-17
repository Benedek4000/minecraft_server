securityGroups = [
  {
    name        = "server"
    description = "For the server."
    rules = [
      {
        type        = "egress"
        description = "outbound http traffic"
        fromPort    = "portHttp"
        toPort      = "portHttp"
        protocol    = "tcp"
        target      = "cidrAnyone"
      },
      {
        type        = "egress"
        description = "outbound https traffic"
        fromPort    = "portHttps"
        toPort      = "portHttps"
        protocol    = "tcp"
        target      = "cidrAnyone"
      },
      {
        type        = "ingress"
        description = "inbound server"
        fromPort    = "portServer"
        toPort      = "portServer"
        protocol    = "tcp"
        target      = "cidrAnyone"
      },
      {
        type        = "ingress"
        description = "inbound rcon"
        fromPort    = "portRcon"
        toPort      = "portRcon"
        protocol    = "tcp"
        target      = "cidrAnyone"
      },
    ]
  }
]
