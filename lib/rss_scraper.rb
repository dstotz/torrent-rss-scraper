require 'simple-rss'
require 'open-uri'

class RSSScraper
  attr_reader :feed_url, :rss

  def initialize(feed_url)
    @feed_url = feed_url
    @rss = SimpleRSS.parse open(feed_url)
    @current_rank = 0
  end
  
  def find_new_torrents
    rss.entries.each do |torrent|
      @current_rank += 1
      next unless torrent[:title].downcase.include?('1080p')
      torrent[:movie] = movie_title(torrent[:title])
      torrent[:current_rank] = @current_rank
      torrent[:messaged] = false
      DB << torrent
    end
  end

  private

  def movie_title(torrent_title)
    title = torrent_title.clone
    remove_values = %w(BRRip BRRIP AAC-ETRG AAC ETRG x264 X264 1080p 1080P WEB-DL AC3-JYK AC3 JYK HDRip KOR H264 EtHD STY Hevc Bluury BluRay DTS 6CH ShAaNiG 2GB BrRip YIFY SPARKS 75GB HDTV WEBRip x26 HDTC CM8 DUALRK 85GB iExTV iExT)
    remove_values += [' cut ', ' HC ', ' GB ']
    remove_values.each { |val| title.gsub!(val, '') }
    title.delete!(')[](-')
    title.gsub!('.', ' ')
    split_values = 1980..TODAY.year
    split_values.each { |date| title = title.split(date.to_s).first }
    title.squeeze(' ').strip
  end
end
