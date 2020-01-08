require 'twitter'
require 'logger'
require 'pathname'

class AineBot

	def initialize(media_path, consumer_key, consumer_secret, access_token, access_token_secret)
		@media_path = media_path
		
		@client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = consumer_key
		  config.consumer_secret     = consumer_secret
		  config.access_token        = access_token
		  config.access_token_secret = access_token_secret
		end

		@logger = Logger.new('bot.log')

	end

	def get_folder
		folder_list = Pathname.new(@media_path).children.select { |c| c.directory? }
		folder = folder_list.sample(1)[0]

		return folder
	end


	def get_post_message(folder_name)

		case folder_name.match(/([a-z]+)/)[0]

		when "episode"
			episode_number 	= folder_name.match(/[0-9][0-9]/)[0].to_i
			post_message 	= "#{episode_number}話のあいねちゃん"

		when "opening"
			opening_number 	= folder_name.match(/[0-9]/)[0].to_i
			
			case opening_number
			when 1
				post_message = "OP曲ありがと⇄大丈夫のあいねちゃん"
			end
		

		when "ending"
			ending_number = folder_name.match(/[0-9]/)[0].to_i

			case ending_number
			when 1
				post_message = "ED曲Believe itのあいねちゃん"
			end
		
		end

		return post_message

	end

	def post

		folder = get_folder()
		media = Pathname.new(folder).children.sample(1)[0]

		unless media.nil?
			post_message = get_post_message(folder.basename.to_s)
			@client.update_with_media(post_message, media.open)
			@logger.info "Posted media #{media.basename} from #{folder.basename}"	
		else
			@logger.info "Folder #{folder.basename} was empty!"	
		end
	end

	def media_path
		@media_path
	end

	def media_path=(media_path)
	  @media_path = media_path
	end

end