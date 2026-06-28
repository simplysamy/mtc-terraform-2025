resource "github_repository" "mtc_repo" {
  for_each    = var.repos
  name        = "mtc-repo-${each.key}"
  description = "${each.value} code for mtc repository"
  visibility  = var.env == "dev" ? "private" : "public"
  auto_init   = true
  provisioner "local-exec" {
    command = "gh repo view ${self.name} --web"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.name}"
  }
}

resource "terraform_data" "repo-clone" {
  for_each   = var.repos
  depends_on = [github_repository_file.index-html, github_repository_file.readme]

  provisioner "local-exec" {
    command = "gh repo clone ${github_repository.mtc_repo[each.key].name}"
  }
}
resource "github_repository_file" "index-html" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[each.key].name
  branch              = "main"
  file                = "index.html"
  content             = "Hello terraform!"
  overwrite_on_create = true
}

resource "github_repository_file" "readme" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[each.key].name
  branch              = "main"
  file                = "README.md"
  content             = "# This ${var.env} is for infra developer"
  overwrite_on_create = true
}

output "clone_urls" {
  value = {
    for i in github_repository.mtc_repo : i.name => i.http_clone_url
    # for name, repo in github_repository.mtc_repo : name => repo.http_clone_url
  }
  description = "Repository URLs"
  sensitive   = false
}