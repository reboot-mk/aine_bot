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

folder_list = Pathname.new(bot_config['media_path']).children.select { |c| c.directory? }
folder = folder_list.sample(1)[0]

media = Pathname.new(folder).children.sample(1)[0]

unless media.nil?
	
	tweet_message = ""

	case folder.basename.to_s.match(/([a-z]+)/)[0]

	when "episode"
		episode_number 	= folder.basename.to_s.match(/[0-9][0-9]/)[0].to_i
		tweet_message 	= "#{episode_number}話のあいねちゃん"

	when "opening"
		opening_number 	= folder.basename.to_s.match(/[0-9]/)[0].to_i
		
		case opening_number
		when 1
			tweet_message 	= "OP曲ありがと⇄大丈夫のあいねちゃん"
		end
	

	when "ending"
		ending_number 	= folder.basename.to_s.match(/[0-9]/)[0].to_i

		case ending_number
		when 1
			tweet_message 	= "ED曲Believe itのあいねちゃん"
		end

	
	end

	client.update_with_media(tweet_message, media.open)
	logger.info "Posted media #{media.basename} from #{folder.basename}"	

else
	logger.info "Folder #{folder.basename} was empty!"
end