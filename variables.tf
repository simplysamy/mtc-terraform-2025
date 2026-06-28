variable "repo_max" {
  description = "Number of repositories to create"
  type        = number
  default     = 2

  validation {
    condition     = var.repo_max < 5
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
  validation {
    condition     = length(var.repos) <= var.repo_max
    error_message = "Please don't deploy more repo than repo_max allows"
  }
}

# variable "visibility" {
#   description = "Repository visibility"
#   type        = string
#   default     = var.env == "dev" ? "private" : "public"

# }