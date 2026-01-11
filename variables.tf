variable "repo_count" {
  description = "Number of repositories to create"
  type        = number
  default     = 1

  validation {
    condition = var.repo_count < 5
    error_message = "Don't deploy more than 5 repo"
  }
}

variable "env" {
  description = "Deployment environment"
  type = string
  validation {
    condition = var.env == "dev" || var.env =="prod"
    error_message = "Env must be 'dev' or 'prod'"
  }
}