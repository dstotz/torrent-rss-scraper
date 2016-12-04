require 'pushbullet'

class PushbulletMessenger
  attr_reader :client, :devices

  def initialize
    Pushbullet.api_token = ENV['PUSHBULLET_API_TOKEN']
  end

  def send(device_id = 'ujECGTf89UysjAiVsKnSTs', url, message)
    Pushbullet::Push.create_link(device_id, 'New movie torrent added', url, message)
  end

  def send_all(url, message)
    devices = Pushbullet::Device.all
    devices.each { |device| self.send(device.iden, url, message) }
  end
end
