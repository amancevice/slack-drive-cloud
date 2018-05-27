output "event_pubsub_topic" {
  description = "Name of Pub/Sub topic for Slack events."
  value       = "${google_pubsub_topic.slack_events.name}"
}

output "event_subscriptions_url" {
  description = "Endpoint for event subscriptions to configure in Slack."
  value       = "${google_cloudfunctions_function.event_publisher.https_trigger_url}"
}

output "redirect_url" {
  description = "Endpoint of redirect for slash command links to configure in Slack Drive."
  value       = "${google_cloudfunctions_function.redirect.https_trigger_url}"
}

output "slash_command_url" {
  description = "Endpoint for slash commands to configure in Slack."
  value       = "${google_cloudfunctions_function.slash_command.https_trigger_url}"
}
