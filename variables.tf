// Google Cloud
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "client_secret" {
  description = "Google Cloud client secret JSON."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

// Slack
variable "verification_token" {
  description = "Slack verification token."
}

variable "web_api_token" {
  description = "Slack Web API token."
}

// App
variable "auth_channels_exclude" {
  description = "Optional list of Slack channel IDs to blacklist."
  type        = "list"
  default     = []
}

variable "auth_channels_include" {
  description = "Optional list of Slack channel IDs to whitelist."
  type        = "list"
  default     = []
}

variable "auth_users_exclude" {
  description = "Optional list of Slack channel IDs to blacklist."
  type        = "list"
  default     = []
}

variable "auth_users_include" {
  description = "Optional list of Slack channel IDs to whitelist."
  type        = "list"
  default     = []
}

variable "color" {
  description = "Default color for slackbot message attachments."
  default     = "good"
}

variable "channel" {
  description = "Slack channel ID for logging events."
}

variable "slash_command" {
  description = "Name of slash command in Slack."
  default     = "drive"
}

// Channel Rename
variable "channel_rename_description" {
  description = "Description of the function."
  default     = "Channel rename event handler"
}

variable "channel_rename_function_name" {
  description = "Cloud Function Name."
  default     = "slack-drive-channel-rename"
}

variable "channel_rename_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-drive"
    deployment-tool = "terraform"
  }
}

variable "channel_rename_memory" {
  description = "Cloud Function Memory."
  default     = 128
}

variable "channel_rename_timeout" {
  description = "Cloud Function Timeout."
  default     = 60
}

variable "channel_rename_trigger_topic" {
  description = "Pub/Sub topic name."
  default     = "channel_rename"
}

// Group Rename
variable "group_rename_description" {
  description = "Description of the function."
  default     = "Group rename event handler"
}

variable "group_rename_function_name" {
  description = "Cloud Function Name."
  default     = "slack-drive-group-rename"
}

variable "group_rename_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-drive"
    deployment-tool = "terraform"
  }
}

variable "group_rename_memory" {
  description = "Cloud Function Memory."
  default     = 128
}

variable "group_rename_timeout" {
  description = "Cloud Function Timeout."
  default     = 60
}

variable "group_rename_trigger_topic" {
  description = "Pub/Sub topic name."
  default     = "group_rename"
}

// Member Joined Channel
variable "member_joined_channel_description" {
  description = "Description of the function."
  default     = "Member joined channel event handler"
}

variable "member_joined_channel_function_name" {
  description = "Cloud Function Name."
  default     = "slack-drive-member-joined-channel"
}

variable "member_joined_channel_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-drive"
    deployment-tool = "terraform"
  }
}

variable "member_joined_channel_memory" {
  description = "Cloud Function Memory."
  default     = 128
}

variable "member_joined_channel_timeout" {
  description = "Cloud Function Timeout."
  default     = 60
}

variable "member_joined_channel_trigger_topic" {
  description = "Pub/Sub topic name."
  default     = "member_joined_channel"
}

// Member Left Channel
variable "member_left_channel_description" {
  description = "Description of the function."
  default     = "Member left channel event handler"
}

variable "member_left_channel_function_name" {
  description = "Cloud Function Name."
  default     = "slack-drive-member-left-channel"
}

variable "member_left_channel_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-drive"
    deployment-tool = "terraform"
  }
}

variable "member_left_channel_memory" {
  description = "Cloud Function Memory."
  default     = 128
}

variable "member_left_channel_timeout" {
  description = "Cloud Function Timeout."
  default     = 60
}

variable "member_left_channel_trigger_topic" {
  description = "Pub/Sub topic name."
  default     = "member_left_channel"
}

// Redirect
variable "redirect_description" {
  description = "Description of the function."
  default     = "Google Drive link redirection"
}

variable "redirect_function_name" {
  description = "Cloud Function for redirecting to Google Drive from Slack."
  default     = "slack-drive-redirect"
}

variable "redirect_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-drive"
    deployment-tool = "terraform"
  }
}

variable "redirect_memory" {
  description = "Memory for Slack redirect."
  default     = 512
}

variable "redirect_timeout" {
  description = "Timeout in seconds for redirect."
  default     = 60
}

// Slash Command
variable "slash_command_description" {
  description = "Description of the function."
  default     = "Slack Drive slash command"
}

variable "slash_command_function_name" {
  description = "Cloud Function for receiving slash-commands from Slack."
  default     = "slack-drive-slash-command"
}

variable "slash_command_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    app             = "slack-drive"
    deployment-tool = "terraform"
  }
}

variable "slash_command_memory" {
  description = "Memory for Slack slash command."
  default     = 512
}

variable "slash_command_timeout" {
  description = "Timeout in seconds for Slack slash command."
  default     = 10
}
