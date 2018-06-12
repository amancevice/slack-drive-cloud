output "redirect_url" {
  description = "Redirect URL."
  value       = "${google_cloudfunctions_function.redirect_function.https_trigger_url}?channel=&user="
}

output "slash_command_url" {
  description = "Slack slash command Request URL."
  value       = "${google_cloudfunctions_function.slash_command_function.https_trigger_url}"
}
