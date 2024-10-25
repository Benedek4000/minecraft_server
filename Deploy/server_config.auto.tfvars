servers = {
  ### EXAMPLE ###
  /* "server-name" = {
    subnet_number = 0
    version       = "1.19.4"
    instance_type = "c7g.medium"
    server_properties = {
      seed        = "[INSERT SEED]"
      motd        = "Server-MOTD"
      online_mode = false
      gamemode    = "creative"
      difficulty  = "normal"
      level_type  = "[INSERT LEVEL TYPE]"
      hardcore    = false
    }
    modding = {
      client = "forge"
      mods   = ["jei", "bridges"]
    }
  } */
  test = {
    subnet_number = 0
    version       = "1.20.4"
    server_properties = {
      motd        = "Test-Server"
      online_mode = false
      gamemode    = "creative"
    }
    /* modding = {
      client = "neoforge"
      mods   = ["jei", "bridges", "ie", "solar", "edivadlib"]
    } */
  }
}
