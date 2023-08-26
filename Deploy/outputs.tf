output "server_info" {
  value = {
    for k, v in module.minecraft-servers : k => v.server_info
  }
}
