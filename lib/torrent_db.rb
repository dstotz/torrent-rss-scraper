require 'sequel'

class TorrentDB
  attr_reader :db, :torrents

  def initialize(db_path)
    @db = Sequel.connect(db_path)
    create_table unless db.table_exists?(:torrents)
    @torrents = db[:torrents]
  end

  def << (entry)
    if torrent = torrents[title: entry[:title]]
      return if torrent[:messaged] || entry[:pubDate] < torrent[:pubDate]
      torrents.where(title: entry[:title]).update(entry)
    else
      torrents.insert(entry)
    end
  end

  def update_messaged(entry)
    torrents.where(title: entry[:title]).update(messaged: true)
  end

  def todays_torrents(include_messaged: false)
    if include_messaged
      torrents.where('pubDate >= ?', TODAY).all
    else
      torrents.where('pubDate >= ?', TODAY).exclude('messaged = ?', true).all
    end
  end

  def create_table
    db.create_table :torrents do
      primary_key :id
      String :title
      String :movie
      String :category
      String :comments
      String :guid
      String :link
      String :dc_creator
      TrueClass :messaged
      DateTime :pubDate
    end
  end
end
