## send-slack

steps to get this working in your slack workspace.

### create your app

you can use this app manifest as a shortcut when creating the app:

```yaml
_metadata:
  major_version: 1
  minor_version: 1
display_information:
  name: notify-cli
  description: simple curl script that sends messages
features:
  bot_user:
    display_name: notify-cli
    always_online: true
  app_home:
    home_tab_enabled: false
    messages_tab_enabled: false
oauth_config:
  scopes:
    bot:
      - chat:write
```

### install the app into your workspace

after installing the app into your workspace, look for the "Install App" menu on the left. this will
show you a token.

on your machine,

```bash
export SLACK_AUTH_TOKEN="the token you see in your web browser"
```

### add your app to a channel

in slack, right-click on a channel and select "View channel details." go to the "Integrations" tab
and click "Add an app."

on your machine:

```bash
export SLACK_CHANNEL="the channel name"
```

### send some messages

```bash
echo "foobar" | send-slack

send-slack <<EOF
foo
bar
EOF

send-slack < foobar.txt
```

the command outputs json which you can parse to detect errors
