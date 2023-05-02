project                    = "minecraft-server"
region                     = "eu-west-1"
website_file_source        = "../Projects/website"
server_file_source         = "../Projects/server_files"
lambda_file_source         = "../Projects/lambda_functions"
control_website_domain_tag = "control."
api_domain_tag             = "api."
minecraft_domain_tag       = "minecraft."
zone_name                  = "benedekkovacs.com"
enable_waf                 = false

cidr_vpc    = "10.0.0.0/16"
cidr_anyone = "0.0.0.0/0"
port_ssh    = 22
port_http   = 80
port_https  = 443
port_server = 25565
port_rcon   = 25575

lambda_role_predefined_policies = ["AmazonEC2FullAccess", "AmazonSSMFullAccess"]
ec2_role_predefined_policies    = ["AmazonSSMFullAccess", "AmazonS3FullAccess"]

az            = "a"
instance_type = "c7g.large"
