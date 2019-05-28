require "bundler/setup"
require 'slack-ruby-client'

LATEST_DATE = 217   # 何日経過後から削除するか
LIMIT_COUNT = 10     # 1回辺り何件削除するか？(channelと)
TOKEN = "Workspace Token"

Slack.configure do |config|
  config.token = TOKEN
end

client = Slack::Web::Client.new


# パブリックチャンネル

puts "パブリックチャンネル"
c_list = []
client.channels_list.channels.each do |c|
  c_list.push({name: "\##{c["name"]}",id: c["id"]})
end

c_list.each do |c|
  c_histories = client.channels_history(channel: c[:name], latest: (Time.now - (60 * 60 * 24 * LATEST_DATE)).to_i, count: LIMIT_COUNT)
  c_histories["messages"].each do |c_history|
    puts "#{c[:name]} : #{Time.at(c_history["ts"].to_i)} : #{c_history["text"]}　　　<delete>"
    client.chat_delete(channel: c[:name], ts: c_history["ts"])
  end
end


# プライベートチャンネル

puts "プライベートチャンネル"
g_list = []
client.groups_list.groups.each do |group|
  g_list.push(name: group["name"], id: group["id"])
end

g_list.each do |g|
  g_histories = client.groups_history(channel: g[:id], latest: (Time.now - (60 * 60 * 24 * LATEST_DATE)).to_i, count: LIMIT_COUNT)
  g_histories["messages"].each do |g_history|
    puts "#{g[:name]} : #{Time.at(g_history["ts"].to_i)} : #{g_history["text"]}　　　<delete>"
    client.chat_delete(channel: g[:id], ts: g_history["ts"])
  end
end


# ファイルストレージ

puts "ファイルストレージ"
client.files_list.files.each_with_index do |file,i| 
  if i < LIMIT_COUNT
    if file[:created].to_i < ( Time.now - (60 * 60 * 24 * LATEST_DATE)).to_i
      puts "#{Time.at(file[:created].to_i)} : #{file[:id]} / #{file[:title]}　　　<delete>"
      client.files_delete(token: TOKEN, file: file[:id])
    end
  else 
    :break
  end
end

p c_list
p g_list
