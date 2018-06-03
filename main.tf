// Config template
data "template_file" "config" {
  template = "${var.config}"

  vars {
    channel                = "${var.channel}"
    color                  = "${var.color}"
    events_pubsub_topic    = "${var.events_pubsub_topic}"
    project                = "${var.project}"
    redirect_function_name = "${var.redirect_function_name}"
    region                 = "${var.region}"
    slash_command          = "${var.slash_command}"
    verification_token     = "${var.verification_token}"
    web_api_token          = "${var.web_api_token}"
  }
}

// Source code module
module "slack_drive" {
  source = "github.com/amancevice/slack-drive?ref=0.5.2"
  config = "${data.template_file.config.rendered}"
}

// Cloud Storage Bucket for storing Cloud Function archives
resource "google_storage_bucket" "slack_drive_bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

// Add service acct as writer to Cloud Storage Bucket
resource "google_storage_bucket_iam_member" "member" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.service_account}"
}

// Event Consumer Cloud Storage archive
resource "google_storage_bucket_object" "event_consumer_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.event_consumer_function_name}.zip"
  source = "${module.slack_drive.event_consumer_output_path}"
}

// Event Publisher Cloud Storage archive
resource "google_storage_bucket_object" "event_publisher_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.event_publisher_function_name}.zip"
  source = "${module.slack_drive.event_publisher_output_path}"
}

// Redirect Cloud Storage archive
resource "google_storage_bucket_object" "redirect_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.redirect_function_name}.zip"
  source = "${module.slack_drive.redirect_output_path}"
}

// Slash Command Cloud Storage archive
resource "google_storage_bucket_object" "slash_command_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.slash_command_function_name}.zip"
  source = "${module.slack_drive.slash_command_output_path}"
}

// Pub/Sub Topic for processing events
resource "google_pubsub_topic" "slack_events" {
  name = "${var.events_pubsub_topic}"
}

// Event Consumer Cloud Function
resource "google_cloudfunctions_function" "event_consumer" {
  name                  = "${var.event_consumer_function_name}"
  description           = "Slack event consumer"
  available_memory_mb   = "${var.event_consumer_memory}"
  source_archive_bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.event_consumer_archive.name}"
  trigger_topic         = "${google_pubsub_topic.slack_events.name}"
  timeout               = "${var.event_consumer_timeout}"
  entry_point           = "consumeEvent"

  labels {
    deployment-tool = "terraform"
  }
}

// Event Publisher Cloud Function
resource "google_cloudfunctions_function" "event_publisher" {
  name                  = "${var.event_publisher_function_name}"
  description           = "Slack event publisher"
  available_memory_mb   = "${var.event_publisher_memory}"
  source_archive_bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.event_publisher_archive.name}"
  trigger_http          = true
  timeout               = "${var.event_publisher_timeout}"
  entry_point           = "publishEvent"

  labels {
    deployment-tool = "terraform"
  }
}

// Redirect Cloud Function
resource "google_cloudfunctions_function" "redirect" {
  name                  = "${var.redirect_function_name}"
  description           = "Redirect to Google Drive"
  available_memory_mb   = "${var.redirect_memory}"
  source_archive_bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.redirect_archive.name}"
  trigger_http          = true
  timeout               = "${var.redirect_timeout}"
  entry_point           = "redirect"

  labels {
    deployment-tool = "terraform"
  }
}

// Slash Command Cloud Function
resource "google_cloudfunctions_function" "slash_command" {
  name                  = "${var.slash_command_function_name}"
  description           = "Slack /slash command HTTP handler"
  available_memory_mb   = "${var.slash_command_memory}"
  source_archive_bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.slash_command_archive.name}"
  trigger_http          = true
  timeout               = "${var.slash_command_timeout}"
  entry_point           = "slashCommand"

  labels {
    deployment-tool = "terraform"
  }
}
