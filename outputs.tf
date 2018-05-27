output "event_subscriptions_url" {
  value = "${google_cloudfunctions_function.event_publisher.https_trigger_url}"
}

output "redirect_url" {
  value = "${google_cloudfunctions_function.redirect.https_trigger_url}"
}

output "slash_command_url" {
  value = "${google_cloudfunctions_function.slash_command.https_trigger_url}"
}
