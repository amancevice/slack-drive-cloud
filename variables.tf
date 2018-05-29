variable "cloud_credentials" {
  description = "Contents of the JSON file used to describe your account credentials, downloaded from Google Cloud Console."
}

variable "cloud_project" {
  description = "The ID of the project to apply any resources to."
}

variable "cloud_region" {
  description = "The region to operate under, if not specified by a given resource."
}

variable "app_version" {
  description = "Slack Drive version."
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "bucket_storage_class" {
  description = "Bucket storage class."
  default     = "MULTI_REGIONAL"
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "source_prefix" {
  description = "Prefix for local source."
  default     = "dist"
}

variable "events_pubsub_topic" {
  description = "Pub/Sub topic name."
  default     = "slack-drive-events"
}

variable "event_consumer_function_name" {
  description = "Cloud Function for consuming events published to Pub/Sub."
  default     = "slack-drive-event-consumer"
}

variable "event_consumer_memory" {
  description = "Memory for Slack event consumer."
  default     = 128
}

variable "event_consumer_timeout" {
  description = "Timeout in seconds for Slack event consumer."
  default     = 60
}

variable "event_publisher_function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-drive-event-publisher"
}

variable "event_publisher_memory" {
  description = "Memory for Slack event listener."
  default     = 128
}

variable "event_publisher_timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 60
}

variable "redirect_function_name" {
  description = "Cloud Function for redirecting to Google Drive from Slack."
  default     = "slack-drive-redirect"
}

variable "redirect_memory" {
  description = "Memory for Slack redirect."
  default     = 128
}

variable "redirect_timeout" {
  description = "Timeout in seconds for redirect."
  default     = 60
}

variable "slash_command_function_name" {
  description = "Cloud Function for receiving slash-commands from Slack."
  default     = "slack-drive-slash-command"
}

variable "slash_command_memory" {
  description = "Memory for Slack slash command."
  default     = 128
}

variable "slash_command_timeout" {
  description = "Timeout in seconds for Slack slash command."
  default     = 60
}
