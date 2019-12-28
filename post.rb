require 'twitter'
require 'json'
require 'logger'
require 'pathname'

logger = Logger.new('bot.log')

bot_config = JSON.parse(File.read('config.json'))

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = bot_config['consumer_key']
  config.consumer_secret     = bot_config['consumer_secret']
  config.access_token        = bot_config['access_token']
  config.access_token_secret = bot_config['access_token_secret']
end

folder_list = Pathname.new(bot_config['image_path']).children.select { |c| c.directory? }
folder = folder_list.sample(1)[0]

image = Pathname.new(folder).children.sample(1)[0]

unless image.nil?
	
	if folder.to_s.include?("episode")
		episode_number = folder.basename.to_s.match(/[0-9][0-9]/)[0].to_i.to_s
		client.update_with_media("#{episode_number}話のあいねちゃん", image.open)
	else
		client.update_with_media("", image.open)
	end

	logger.info "Posted image #{image.basename} from #{folder.basename}"	

else
	logger.info "Folder #{folder.basename} was empty!"
end