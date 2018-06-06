output "version" {
  description = "Slack Drive module version"
  value       = "${local.version}"
}

output "pubsub_topic" {
  description = "Name of Pub/Sub topic for Slack events."
  value       = "${module.slack_event_publisher.pubsub_topic}"
}

output "event_publisher_url" {
  description = "Endpoint for event subscriptions to configure in Slack."
  value       = "${module.slack_event_publisher.event_publisher_url}"
}

output "redirect_url" {
  description = "Endpoint of redirect for slash command links to configure in Slack Drive."
  value       = "${module.slack_drive_redirect.redirect_url}"
}

output "slash_command_url" {
  description = "Endpoint for slash commands to configure in Slack."
  value       = "${module.slack_drive_slash_command.slash_command_url}"
}
