require 'twitter'
require 'json'
require 'logger'

logger = Logger.new('bot.log')

bot_config = JSON.parse(File.read('config.json'))

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = bot_config['consumer_key']
  config.consumer_secret     = bot_config['consumer_secret']
  config.access_token        = bot_config['access_token']
  config.access_token_secret = bot_config['access_token_secret']
end

image = Dir.entries(bot_config['image_path']).sample(1)[0]

client.update_with_media("", File.new("#{bot_config['image_path']}/#{image}"))
logger.info "Posted image #{image}"