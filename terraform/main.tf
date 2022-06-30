
locals {
  tags = {
    app        = "jira_webapp_poc"
    stage      = "poc"
    managed-by = "terraform"
  }
}

module "jira_web_app" {
  source = "./modules/jira-web-app"

  tags = local.tags
}

