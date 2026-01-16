# resource "random_id" "random" {
#   byte_length = 2
#   count       = var.repo_count
# }

resource "github_repository" "mtc_repo" {
  for_each    = var.repos
  name        = "mtc-repo-${each.key}"
  description = "${each.value} code for mtc repository"
  visibility  = var.env == "dev" ? "private" : "public"
  auto_init   = true
}

resource "github_repository_file" "index-html" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[count.index].name
  branch              = "main"
  file                = "index.html"
  content             = "Hello terraform!"
  overwrite_on_create = true
}

resource "github_repository_file" "readme" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[count.index].name
  branch              = "main"
  file                = "README.md"
  content             = "# This ${var.env} is for infra developer"
  overwrite_on_create = true
}

output "clone_urls" {
  value = {
    for index in github_repository.mtc_repo[*] : index.name => index.http_clone_url
  }
  description = "repository names"
  sensitive   = false
}