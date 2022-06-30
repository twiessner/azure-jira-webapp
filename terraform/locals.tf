locals {
    location = "westeu"
    resource_group_name = "rg_jira_webapp_poc"
    tags = {
        app = "jira_webapp_poc"
        stage = "poc"
        managed-by = "terraform"
    }
}