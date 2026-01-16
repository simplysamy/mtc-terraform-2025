variable "repo_count" {
  description = "Number of repositories to create"
  type        = number
  default     = 1

  validation {
    condition     = var.repo_count < 5
    error_message = "Don't deploy more than 5 repo"
  }
}

variable "env" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Env must be 'dev' or 'prod'"
  }
}

variable "repos" {
  description = "Repositories"
  type        = set(string)
}

# variable "visibility" {
#   description = "Repository visibility"
#   type        = string
#   default     = var.env == "dev" ? "private" : "public"

# }