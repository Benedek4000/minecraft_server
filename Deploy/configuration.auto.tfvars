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
apiFile                    = "api.json"
logFormatFile              = "log_format.json"

sgData = {
  portSsh    = 22
  portHttp   = 80
  portHttps  = 443
  portServer = 25565
  portRcon   = 25575
  cidrVpc    = ["10.0.0.0/16"]
  cidrAnyone = ["0.0.0.0/0"]
}

az            = "a"
instance_type = "c7g.medium"
