// group_rename.js

// App
const config = require('./config.json');

// Slack
const { WebClient } = require('@slack/client');
const slack = new WebClient(config.slack.web_api_token);

// Google Drive
const service = require('./client_secret.json');
const { google } = require('googleapis');
const mimeTypeFolder = 'application/vnd.google-apps.folder';
const scopes = ['https://www.googleapis.com/auth/drive'];
const jwt = new google.auth.JWT(service.client_email, './client_secret.json', null, scopes);
const drive = google.drive({version: 'v3', auth: jwt});

/**
 * Log PubSub message.
 *
 * @param {object} e      PubSub message.
 * @param {object} e.data Base64-encoded message data.
 */
function logEvent(e) {
  console.log(`PUBSUB MESSAGE ${JSON.stringify(e)}`);
  return e;
}

/**
 * Base64-decode PubSub message.
 *
 * @param {object} e      PubSub message.
 * @param {object} e.data Base64-encoded message data.
 */
function decodeEvent(e) {
  return JSON.parse(Buffer.from(e.data, 'base64').toString());
}

/**
 * Get Slack channel info.
 *
 * @param {object} e Slack event object message.
 * @param {object} e.event Slack event object.
 */
function getChannel(e) {
  return slack.groups.info({channel: e.event.channel})
    .then((res) => {
      console.log(`CHANNEL #${res.group.name}`);
      return res.channel;
    })
    .catch((err) => {
      console.error(JSON.stringify(err));
      throw err;
    });
}

/**
 * Rename a Google Drive folder
 *
 * @param {object} channel Slack channel object.
 */
function createOrRenameFolder(channel) {
  // Search for folder by channel ID in `appProperties`
  return drive.files.list({
      q: `appProperties has { key='channel' and value='${channel.id}' }`
    })
    .then((res) => {

      // Create folder
      if (res.data.files.length === 0) {
        console.log(`CREATING FOLDER #${channel.name}`);
        return drive.files.create({
            resource: {
              name: `#${channel.name}`,
              mimeType: mimeTypeFolder,
              appProperties: {
                channel: channel.id
              }
            }
          });
      }

      // Rename folder
      else {
        res.data.files.map((x) => { folder = x; });
        console.log(`RENAMING FOLDER ${folder.name} => #${channel.name}`);
        return drive.files.update({
            fileId: folder.id,
            resource: {
              name: `#${channel.name}`
            }
          });
      }
    });
}

/**
 * Post success message to Slack
 *
 * @param {object} e Slack event object message.
 * @param {object} e.event Slack event object.
 */
function postRecord(e) {

  // Build message
  record = interpolate(messages.success, {
    channel: e.event.channel_type === 'C' ? `<#${channel.id}>` : `#${channel.name}`,
    cmd: config.slack.slash_command,
    event: JSON.stringify(e.event).replace(/"/g, '\\"'),
    title: titlize(e.event.type),
    ts: e.event.event_ts,
    user: e.event.user === undefined ? 'N/A' : `<@${e.event.user}>`
  });
  record.channel = config.slack.channel;

  // Post record message
  console.log(`POSTING RECORD ${JSON.stringify(record)}`);
  return slack.chat.postMessage(record)
    .then((res) => { return; })
    .catch((err) => { console.error(JSON.stringify(err)); throw err; });
}

/**
 * Post error message to Slack.
 *
 * @param {object} err Error.
 * @param {object} e Slack event object.
 */
function postError(err, e, callback) {
  // Build message
  const error = interpolate(messages.error, {
    error_message: err.message,
    error_name: err.name,
    event: JSON.stringify(e).replace(/"/g, '\\"'),
    stack: err.stack.replace(/\n/g, '\\n'),
    ts: new Date()/1000
  });
  error.channel = config.slack.channel;

  // Post error message back to Slack
  console.error(`POSTING ERROR ${JSON.stringify(error)}`);
  slack.chat.postMessage(error);

  callback();
}

/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {object} event The Cloud Functions event.
 * @param {function} callback The callback function.
 */
exports.consumeEvent = (event, callback) => {
  Promise.resolve(event.data)
    .then(logEvent)
    .then(decodeEvent)
    .then(getChannel)
    .then(createOrRenameFolder)
    .then(postRecord)
    .then(callback)
    .catch((err) => postError(err, event.data, callback));
};
