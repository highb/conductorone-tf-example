# conductorone-tf-example

Example Terraform configuration for managing a ConductorOne app using the [ConductorOne Terraform provider](https://registry.terraform.io/providers/ConductorOne/conductorone/latest).

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- A ConductorOne tenant with API credentials (client ID + secret, or an access token)

## Getting started

1. **Clone this repo** and update `main.tf` to point at your ConductorOne tenant:

   ```hcl
   provider "conductorone" {
     server_url    = "https://C1_API_ENDPOINT_WITH_PORT"
     client_id     = "" # or set CONDUCTORONE_CLIENT_ID
     client_secret = "" # or set CONDUCTORONE_CLIENT_SECRET
   }
   ```

   Replace `C1_API_ENDPOINT_WITH_PORT` with your actual ConductorOne API endpoint and port (e.g. `your-tenant.conductor.one`).

2. **Set credentials** via environment variables (recommended) so they stay out of version control:

   ```bash
   export CONDUCTORONE_CLIENT_ID="..."
   export CONDUCTORONE_CLIENT_SECRET="..."
   ```

   Or use a static bearer token (takes priority over all other auth):

   ```bash
   export CONDUCTORONE_ACCESS_TOKEN="..."
   ```

   To create API credentials, go to **Settings > API Keys** in your ConductorOne admin console.

3. **Initialize and apply:**

   ```bash
   terraform init
   terraform apply
   ```

## Modifying the configuration

The included `main.tf` creates a single ConductorOne app called "Terraforming Mars". To experiment further:

### Change the app

Edit the `conductorone_app` resource to use a different name:

```hcl
resource "conductorone_app" "my_app" {
  display_name = "My Custom App"
}
```

### Add a policy

```hcl
resource "conductorone_policy" "example" {
  display_name = "Example Access Policy"
  description  = "Managed by Terraform"
}
```

### Add an app entitlement

```hcl
data "conductorone_app_entitlement" "example" {
  app_id = conductorone_app.my_app.id
  alias  = "member"
}
```

### Use the provider version from the registry

You can pin or upgrade the provider version in the `required_providers` block:

```hcl
terraform {
  required_providers {
    conductorone = {
      source  = "conductorone/conductorone"
      version = "~> 1.0"
    }
  }
}
```

Run `terraform init -upgrade` after changing the version constraint.

## Provider documentation

See the full list of supported resources and data sources in the [ConductorOne provider docs](https://registry.terraform.io/providers/ConductorOne/conductorone/latest/docs).

## Using a local provider build

To test against a locally-built provider binary instead of the registry version, create a `dev.tfrc` file with [dev overrides](https://developer.hashicorp.com/terraform/cli/config/config-file#development-overrides-for-provider-developers) and run:

```bash
TF_CLI_CONFIG_FILE=dev.tfrc terraform plan
```

No `terraform init` is needed when using dev overrides.
