terraform {
  required_providers {
    conductorone = {
      source  = "conductorone/conductorone"
      version = "1.0.40"
    }
  }
}

provider "conductorone" {
  server_url    = "https://c1dev.highb.d2.ductone.com:2443"
  client_id     = "" # or set CONDUCTORONE_CLIENT_ID
  client_secret = "" # or set CONDUCTORONE_CLIENT_SECRET
}

resource "conductorone_app" "terraforming_mars" {
  display_name = "Terraforming Mars"
}
