variable "repo_count" {
  description = "Number of repositories to create"
  type        = number
  default     = 1

  validation {
    condition = var.repo_count < 5
    error_message = "Don't deploy more than 5 repo"
  }
}

