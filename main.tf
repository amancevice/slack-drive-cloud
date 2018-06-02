// Config template
data "template_file" "config" {
  template = "${file("${path.module}/slack-drive/config.example.json")}"

  vars {
    project                = "${var.project}"
    region                 = "${var.region}"
    events_pubsub_topic    = "${var.events_pubsub_topic}"
    redirect_function_name = "${var.redirect_function_name}"
    web_api_token          = "${var.web_api_token}"
    verification_token     = "${var.verification_token}"
    channel                = "${var.channel}"
    color                  = "${var.color}"
    slash_command          = "${var.slash_command}"
  }
}

// Event Consumer archive
data "archive_file" "event_consumer" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.event_consumer_function_name}.zip"

  source {
    content  = "${file("${path.module}/slack-drive/src/event-consumer/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/event-consumer/package.json")}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/messages.json")}"
    filename = "messages.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("client_secret.json")}"
    filename = "client_secret.json"
  }
}

// Event Publisher archive
data "archive_file" "event_publisher" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.event_publisher_function_name}.zip"

  source {
    content  = "${file("${path.module}/slack-drive/src/event-publisher/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/event-publisher/package.json")}"
    filename = "package.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("client_secret.json")}"
    filename = "client_secret.json"
  }
}

// Redirect archive
data "archive_file" "redirect" {
  type        = "zip"
  output_path = "${path.module}/dist/${redirect_function_name}.zip"

  source {
    content  = "${file("${path.module}/slack-drive/src/redirect/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/redirect/package.json")}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/messages.json")}"
    filename = "messages.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("client_secret.json")}"
    filename = "client_secret.json"
  }
}

// Redirect archive
data "archive_file" "slash_command" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.slash_command_function_name}.zip"

  source {
    content  = "${file("${path.module}/slack-drive/src/slash-command/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/slash-command/package.json")}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/slack-drive/src/messages.json")}"
    filename = "messages.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }
}

// Cloud Storage Bucket for storing Cloud Function archives
resource "google_storage_bucket" "slack_drive_bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

// Add service acct as writer to Cloud Storage Bucket
resource "google_storage_bucket_iam_member" "member" {
  bucket = "${var.bucket_name}"
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.service_account}"
}

// Event Consumer Cloud Storage archive
resource "google_storage_bucket_object" "event_consumer_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.event_consumer_function_name}.zip"
  source = "${data.archive_file.event_consumer.output_path}"
}

// Event Publisher Cloud Storage archive
resource "google_storage_bucket_object" "event_publisher_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.event_publisher_function_name}.zip"
  source = "${data.archive_file.event_publisher.output_path}"
}

// Redirect Cloud Storage archive
resource "google_storage_bucket_object" "redirect_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.redirect_function_name}.zip"
  source = "${data.archive_file.redirect.output_path}"
}

// Slash Command Cloud Storage archive
resource "google_storage_bucket_object" "slash_command_archive" {
  bucket = "${google_storage_bucket.slack_drive_bucket.name}"
  name   = "${var.bucket_prefix}${var.slash_command_function_name}.zip"
  source = "${data.archive_file.slash_command.output_path}"
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
