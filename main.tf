

resource "github_repository" "mtc_repo" {
  for_each    = var.repos
  name        = "mtc-repo-${each.key}"
  description = "Code for mtc repository"
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
  file                = each.value.filename
  content             = "Hello terraform!"
  overwrite_on_create = true
  lifecycle {
    ignore_changes = [
      content, 
    ]
  }
}

resource "github_repository_file" "readme" {
  for_each            = var.repos
  repository          = github_repository.mtc_repo[each.key].name
  branch              = "main"
  file                = "README.md"
  content             = templatefile("templates/readme.tftpl", {
    env = var.env,
    lang = each.value.lang,
    repo = each.key
    author_name = data.github_user.current.name
  })

  # content             = <<-EOT  
  #                         # This is a ${var.env} ${each.value.lang} repository for ${each.key} developers.
  #                         The Infra was last edited by ${data.github_user.current.name}
  #                         EOT

  overwrite_on_create = true
  # lifecycle {
  #   ignore_changes = [
  #     content, 
  #   ]
  # }
}

