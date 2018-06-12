provider "archive" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

locals {
  version = "1.0.2"

  auth {
    channels {
      exclude = ["${var.auth_channels_exclude}"]
      include = ["${var.auth_channels_include}"]
    }
    users {
      exclude = ["${var.auth_users_exclude}"]
      include = ["${var.auth_users_include}"]
    }
  }
}

data "template_file" "config" {
  template = "${file("${path.module}/src/config.tpl")}"

  vars {
    channel            = "${var.channel}"
    color              = "${var.color}"
    project            = "${var.project}"
    redirect           = "${var.redirect_function_name}"
    region             = "${var.region}"
    slash_command      = "${var.slash_command}"
    verification_token = "${var.verification_token}"
    web_api_token      = "${var.web_api_token}"
  }
}

data "template_file" "channel_rename_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
    name    = "slack-drive-channel-rename"
  }
}

data "template_file" "group_rename_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
    name    = "slack-drive-group-rename"
  }
}

data "template_file" "member_joined_channel_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
    name    = "slack-drive-member-joined-channel"
  }
}

data "template_file" "member_left_channel_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
    name    = "slack-drive-member-left-channel"
  }
}

data "template_file" "redirect_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
    name    = "slack-drive-redirect"
  }
}

data "template_file" "slash_command_package" {
  template = "${file("${path.module}/src/package.tpl")}"

  vars {
    version = "${local.version}"
    name    = "slack-drive-slash-command"
  }
}

data "archive_file" "channel_rename_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.channel_rename_function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${var.client_secret}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/channel_rename.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.channel_rename_package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/src/messages.json")}"
    filename = "messages.json"
  }
}

data "archive_file" "group_rename_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.group_rename_function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${var.client_secret}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/group_rename.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.group_rename_package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/src/messages.json")}"
    filename = "messages.json"
  }
}

data "archive_file" "member_joined_channel_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.member_joined_channel_function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${var.client_secret}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/member_joined_channel.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.member_joined_channel_package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/src/messages.json")}"
    filename = "messages.json"
  }
}

data "archive_file" "member_left_channel_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.member_left_channel_function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${var.client_secret}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/member_left_channel.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.member_left_channel_package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/src/messages.json")}"
    filename = "messages.json"
  }
}

data "archive_file" "redirect_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.redirect_function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${var.client_secret}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/redirect.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.redirect_package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/src/messages.json")}"
    filename = "messages.json"
  }
}

data "archive_file" "slash_command_archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.slash_command_function_name}-${local.version}.zip"

  source {
    content  = "${jsonencode("${local.auth}")}"
    filename = "auth.json"
  }

  source {
    content  = "${var.client_secret}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/slash_command.js")}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.slash_command_package.rendered}"
    filename = "package.json"
  }

  source {
    content  = "${file("${path.module}/src/messages.json")}"
    filename = "messages.json"
  }
}

resource "google_storage_bucket_object" "channel_rename_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.channel_rename_function_name}-${local.version}.zip"
  source = "${data.archive_file.channel_rename_archive.output_path}"
}

resource "google_storage_bucket_object" "group_rename_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.group_rename_function_name}-${local.version}.zip"
  source = "${data.archive_file.group_rename_archive.output_path}"
}

resource "google_storage_bucket_object" "member_joined_channel_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.member_joined_channel_function_name}-${local.version}.zip"
  source = "${data.archive_file.member_joined_channel_archive.output_path}"
}

resource "google_storage_bucket_object" "member_left_channel_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.member_left_channel_function_name}-${local.version}.zip"
  source = "${data.archive_file.member_left_channel_archive.output_path}"
}

resource "google_storage_bucket_object" "redirect_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.redirect_function_name}-${local.version}.zip"
  source = "${data.archive_file.redirect_archive.output_path}"
}

resource "google_storage_bucket_object" "slash_command_archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.slash_command_function_name}-${local.version}.zip"
  source = "${data.archive_file.slash_command_archive.output_path}"
}

resource "google_cloudfunctions_function" "channel_rename_function" {
  available_memory_mb   = "${var.channel_rename_memory}"
  description           = "${var.channel_rename_description}"
  entry_point           = "consumeEvent"
  labels                = "${var.channel_rename_labels}"
  name                  = "${var.channel_rename_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.channel_rename_archive.name}"
  timeout               = "${var.channel_rename_timeout}"
  trigger_topic         = "${var.channel_rename_trigger_topic}"
}

resource "google_cloudfunctions_function" "group_rename_function" {
  available_memory_mb   = "${var.group_rename_memory}"
  description           = "${var.group_rename_description}"
  entry_point           = "consumeEvent"
  labels                = "${var.group_rename_labels}"
  name                  = "${var.group_rename_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.group_rename_archive.name}"
  timeout               = "${var.group_rename_timeout}"
  trigger_topic         = "${var.group_rename_trigger_topic}"
}

resource "google_cloudfunctions_function" "member_joined_channel_function" {
  available_memory_mb   = "${var.member_joined_channel_memory}"
  description           = "${var.member_joined_channel_description}"
  entry_point           = "consumeEvent"
  labels                = "${var.member_joined_channel_labels}"
  name                  = "${var.member_joined_channel_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.member_joined_channel_archive.name}"
  timeout               = "${var.member_joined_channel_timeout}"
  trigger_topic         = "${var.member_joined_channel_trigger_topic}"
}

resource "google_cloudfunctions_function" "member_left_channel_function" {
  available_memory_mb   = "${var.member_left_channel_memory}"
  description           = "${var.member_left_channel_description}"
  entry_point           = "consumeEvent"
  labels                = "${var.member_left_channel_labels}"
  name                  = "${var.member_left_channel_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.member_left_channel_archive.name}"
  timeout               = "${var.member_left_channel_timeout}"
  trigger_topic         = "${var.member_left_channel_trigger_topic}"
}

resource "google_cloudfunctions_function" "redirect_function" {
  available_memory_mb   = "${var.redirect_memory}"
  description           = "${var.redirect_description}"
  entry_point           = "redirect"
  labels                = "${var.redirect_labels}"
  name                  = "${var.redirect_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.redirect_archive.name}"
  timeout               = "${var.redirect_timeout}"
  trigger_http          = true
}

resource "google_cloudfunctions_function" "slash_command_function" {
  available_memory_mb   = "${var.slash_command_memory}"
  description           = "${var.slash_command_description}"
  entry_point           = "slashCommand"
  labels                = "${var.slash_command_labels}"
  name                  = "${var.slash_command_function_name}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.slash_command_archive.name}"
  timeout               = "${var.slash_command_timeout}"
  trigger_http          = true
}
