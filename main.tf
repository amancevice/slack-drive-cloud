provider "google" {
  credentials = "${var.cloud_credentials}"
  project     = "${var.cloud_project}"
  region      = "${var.cloud_region}"
  version     = "~> 1.13"
}

resource "google_storage_bucket" "slack_drive_bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

resource "google_storage_bucket_object" "event_consumer_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.event_consumer_function_name}-${var.event_consumer_version}.zip"
  source = "${var.source_prefix}${var.event_consumer_function_name}-${var.event_consumer_version}.zip"
}

resource "google_storage_bucket_object" "event_publisher_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.event_publisher_function_name}-${var.event_publisher_version}.zip"
  source = "${var.source_prefix}${var.event_publisher_function_name}-${var.event_publisher_version}.zip"
}

resource "google_storage_bucket_object" "redirect_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.redirect_function_name}-${var.redirect_version}.zip"
  source = "${var.source_prefix}${var.redirect_function_name}-${var.redirect_version}.zip"
}

resource "google_storage_bucket_object" "slash_command_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.slash_command_function_name}-${var.slash_command_version}.zip"
  source = "${var.source_prefix}${var.slash_command_function_name}-${var.slash_command_version}.zip"
}

resource "google_pubsub_topic" "slack_events" {
  name = "${var.events_pubsub_topic}"
}

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
