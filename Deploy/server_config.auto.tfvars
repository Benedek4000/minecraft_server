servers = {
  test = {
    subnet_number = 0
    version       = "1.20.4"
    server_properties = {
      motd     = "Forge-Test-Server"
      gamemode = "creative"
    }
    modding = {
      client = "forge"
      #mods   = ["jei", "balm", "naturescompass", "waystones", "terrablender"]
      mods = ["mtr"]
    }
  }
}
