project              = "minecraft-server"
region               = "eu-west-1"
server_file_source   = "server_files"
api_domain_tag       = "api."
minecraft_domain_tag = "minecraft."
zone_name            = "benedekkovacs.com"

cidr_vpc    = "10.0.0.0/16"
cidr_anyone = "0.0.0.0/0"
port_ssh    = 22
port_http   = 80
port_https  = 443
port_server = 25565
port_rcon   = 25575

lambda_role_predefined_policies = ["AmazonEC2FullAccess", "AmazonSSMFullAccess"]
ec2_role_predefined_policies    = ["AmazonSSMFullAccess"]

lambda_file_source = "lambda_functions"

az            = "a"
instance_type = "t4g.small"
stop_hour     = 6
