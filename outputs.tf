output "clone_urls" {
  value = {
    for i in github_repository.mtc_repo : i.name => [i.ssh_clone_url, i.http_clone_url]
    # for name, repo in github_repository.mtc_repo : name => repo.http_clone_url
  }
  description = "Repository URLs"
  sensitive   = false
}