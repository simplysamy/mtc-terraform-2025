terraform {
  backend "local" {
    path = "..github/state/terraform.tfstate"
  }
}