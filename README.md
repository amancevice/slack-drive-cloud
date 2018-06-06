# Slack Drive Terraform Module

Terraform module for deploying Slack Drive to Google Cloud.

## Quickstart

Create a `terraform.tfvars` file with your access keys & custom configuration:

```terraform
# terraform.tfvars

bucket_name        = "<cloud-storage-bucket>"
channel            = "<slack-drive-logging-channel>"
project            = "<cloud-project-123456>"
service_account    = "<slack-drive@<cloud-project-123456>.iam.gserviceaccount.com>"
verification_token = "<verification-token>"
web_api_token      = "<web-api-token>"

users {

  # exclude these users
  excluded = [
    "USLACKBOT"
  ]

  # *only* allow these users
  included = [
  ]

}

```

Create a `terraform.tf` file with these contents:

```terraform
# terraform.tf

provider "google" {
  credentials = "${file("${var.client_secret}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.13"
}

module "slack_drive" {
  source             = "amancevice/slack-drive/google"
  version            = "<module-version>"
  bucket_name        = "${var.bucket_name}"
  channel            = "${var.channel}"
  client_secret      = "${file("${var.client_secret}")}"
  color              = "${var.color}"
  project            = "${var.project}"
  service_account    = "${var.service_account}"
  verification_token = "${var.verification_token}"
  web_api_token      = "${var.web_api_token}"
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "channel" {
  description = "Slack channel ID for logging messages."
}

variable "client_secret" {
  description = "Google Cloud client secret JSON filename."
  default     = "client_secret.json"
}

variable "color" {
  description = "Default color for slackbot message attachments."
  default     = "good"
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

variable "service_account" {
  description = "An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com."
}

variable "verification_token" {
  description = "Slack verification token."
}

variable "web_api_token" {
  description = "Slack Web API token."
}

output "pubsub_topic" {
  value = "${module.slack_drive.event_pubsub_topic}"
}

output "event_subscriptions_url" {
  value = "${module.slack_drive.event_subscriptions_url}"
}

output "redirect_url" {
  value = "${module.slack_drive.redirect_url}"
}

output "slash_command_url" {
  value = "${module.slack_drive.slash_command_url}"
}
```

In a terminal window, initialize the state:

```bash
terraform init
```

Then review & apply the changes

```bash
terraform apply
```
