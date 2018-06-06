locals {
  version = "0.7.1"
}

resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.bucket.name}"
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.service_account}"
}

module "slack_event_publisher" {
  source             = "amancevice/slack-event-publisher/google"
  version            = "0.1.1"
  bucket_name        = "${google_storage_bucket.bucket.name}"
  client_secret      = "${var.client_secret}"
  function_name      = "${var.event_publisher_function_name}"
  memory             = "${var.event_publisher_memory}"
  project            = "${var.project}"
  pubsub_topic       = "${var.pubsub_topic}"
  timeout            = "${var.event_publisher_timeout}"
  verification_token = "${var.verification_token}"
}

module "slack_drive_event_consumer" {
  source        = "amancevice/slack-drive-event-consumer/google"
  version       = "0.1.2"
  bucket_name   = "${google_storage_bucket.bucket.name}"
  channel       = "${var.channel}"
  client_secret = "${var.client_secret}"
  color         = "${var.color}"
  function_name = "${var.event_consumer_function_name}"
  memory        = "${var.event_consumer_memory}"
  project       = "${var.project}"
  timeout       = "${var.event_consumer_timeout}"
  web_api_token = "${var.web_api_token}"
}

module "slack_drive_redirect" {
  source        = "amancevice/slack-drive-redirect/google"
  version       = "0.1.2"
  bucket_name   = "${google_storage_bucket.bucket.name}"
  channel       = "${var.channel}"
  client_secret = "${var.client_secret}"
  function_name = "${var.redirect_function_name}"
  memory        = "${var.redirect_memory}"
  project       = "${var.project}"
  timeout       = "${var.redirect_timeout}"
  web_api_token = "${var.web_api_token}"
}


module "slack_drive_slash_command" {
  source             = "amancevice/slack-drive-slash-command/google"
  version            = "0.1.3"
  bucket_name        = "${google_storage_bucket.bucket.name}"
  channel            = "${var.channel}"
  client_secret      = "${var.client_secret}"
  color              = "${var.color}"
  function_name      = "${var.slash_command_function_name}"
  memory             = "${var.slash_command_memory}"
  project            = "${var.project}"
  redirect_url       = "${module.slack_drive_redirect.redirect_url}"
  timeout            = "${var.slash_command_timeout}"
  verification_token = "${var.verification_token}"
  web_api_token      = "${var.web_api_token}"
}
