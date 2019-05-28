Workspaceごとのアクセストークンが必要になります
https://api.slack.com/custom-integrations/legacy-tokens

tokenを発行してコード内に貼り付ける
※tokenを発行した人の権限で見れる範囲のみ適用されます。

```bash
$ bundle install --path vendor/bundle -j4
```

```bash
$ ruby slack-bot.rb
```
