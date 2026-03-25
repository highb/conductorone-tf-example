terraform {
  required_providers {
    conductorone = {
      source  = "conductorone/conductorone"
      version = "1.0.40"
    }
  }
}

provider "conductorone" {
  server_url    = "https://C1_API_ENDPOINT_WITH_PORT"
  client_id     = "" # or set CONDUCTORONE_CLIENT_ID
  client_secret = "" # or set CONDUCTORONE_CLIENT_SECRET
}

resource "conductorone_app" "terraforming_mars" {
  display_name = "Terraforming Mars"
}
