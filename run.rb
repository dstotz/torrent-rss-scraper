$LOAD_PATH << File.expand_path('./lib', __dir__)
require 'torrent_db'
require 'pushbullet_messenger'
require 'rss_scraper'

DB = TorrentDB.new('sqlite://./db/feed.db')
MESSENGER = PushbulletMessenger.new
TODAY = Date.today.to_time

feed_url = 'https://thepiratebay.org/rss/top100/207'
RSSScraper.new(feed_url).find_new_torrents

DB.todays_torrents.each do |torrent|
  message = "#{torrent[:movie]}\n\nUploaded by: #{torrent[:dc_creator]}\n#{torrent[:title]}"
  torrent_url = torrent[:guid]
  MESSENGER.send(torrent_url, message)
  DB.update_messaged(torrent)
end
