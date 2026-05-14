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

To test against a locally-built provider binary instead of the registry version, use Terraform's [development overrides](https://developer.hashicorp.com/terraform/cli/config/config-file#development-overrides-for-provider-developers).

### From a local checkout

1. Clone and build the provider:

   ```bash
   git clone https://github.com/ConductorOne/terraform-provider-conductorone.git
   cd terraform-provider-conductorone
   go build -o terraform-provider-conductorone
   ```

   Note the absolute path to the directory containing the binary (e.g. `/Users/you/src/terraform-provider-conductorone`).

2. In this repo, create a `dev.tfrc` file pointing at that directory:

   ```hcl
   provider_installation {
     dev_overrides {
       "ConductorOne/conductorone" = "/absolute/path/to/terraform-provider-conductorone"
     }
     direct {}
   }
   ```

3. Run Terraform with the override config:

   ```bash
   TF_CLI_CONFIG_FILE=dev.tfrc terraform plan
   ```

   No `terraform init` is needed — dev overrides bypass the registry and lock file. Terraform will print a warning confirming the override is in effect.

To test a branch or a PR from a fork, `git checkout` the relevant ref (or add the fork as a remote with `git remote add fork https://github.com/<user>/terraform-provider-conductorone.git && git fetch fork`) before running `go build`.

### From a remote GitHub branch via `go install`

Terraform itself has no Git source for providers, but `go install` will fetch and build any branch or commit in one step:

```bash
GOBIN=$(pwd)/bin go install github.com/conductorone/terraform-provider-conductorone@<branch-or-sha>
```

The module path must be lowercase (`conductorone`) even though the GitHub URL uses mixed case — `go install` enforces the path declared in the upstream `go.mod`.

This drops the binary in `./bin/terraform-provider-conductorone`. Point `dev.tfrc` at that directory:

```hcl
provider_installation {
  dev_overrides {
    "ConductorOne/conductorone" = "/absolute/path/to/this/repo/bin"
  }
  direct {}
}
```

Then run `TF_CLI_CONFIG_FILE=dev.tfrc terraform plan` as above. Forks usually keep the upstream module path, so `go install github.com/<user>/...` will fail with a path mismatch — use the local-checkout flow for forks.

### Switching back to the registry version

Unset the override by running Terraform without `TF_CLI_CONFIG_FILE`. If you've added or changed the `required_providers` version constraint, run `terraform init -upgrade` to refresh the lock file.
