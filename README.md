# Slack Drive Terraform Module

Terraform module for deploying Slack Drive to Google Cloud

## Simple Config

After following the deployment instructions on the [Slack Drive](https://github.com/amancevice/slack-drive) homepage, the following configuration is a simple use case for deploying the app:

```terraform
module "slack_drive_cloud" {
  source            = "amancevice/slack-drive/google"
  version           = "0.2.0"
  app_version       = "0.1.3"
  bucket_name       = "my-project-slack-drive"
  cloud_credentials = "${file("client_secret.json")}"
  cloud_project     = "my-project"
  service_account   = "slack-drive@my-project.iam.gserviceaccount.com"
}
```
