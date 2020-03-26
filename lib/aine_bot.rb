require 'twitter'
require 'logger'
require 'pathname'
require 'terminal-table'

class AineBot

	def initialize(media_path, consumer_key, consumer_secret, access_token, access_token_secret)
		
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key			= consumer_key
			config.consumer_secret		= consumer_secret
			config.access_token 		= access_token
			config.access_token_secret 	= access_token_secret
		end

		@media_formats = ['.jpg', '.mp4', '.gif', '.png']

		@media_path = media_path

		@folder_list = Pathname.new(@media_path).children.sort.select { |c| c.directory? }

		@logger = Logger.new('bot.log')

	end

	def get_media(folder)
	
		folder_pn = Pathname.new(folder)
		
		media_list = folder_pn.children.select { |file| @media_formats.include?(File.extname(file)) }

		if(folder_pn.basename.to_s.include?("eyecatch"))
			return media_list
		else
			return media_list.sample(1)[0]
		end

	end

	def get_post_message(folder_name)

		case folder_name.match(/([A-z]+)/)[0]

		# Friends

		when "fure_ep"

			episode_number 	= folder_name.match(/[0-9][0-9]/)[0].to_i
			post_message 	= "#{episode_number}話のあいねちゃん"

		when "fure_opening"
			opening_number 	= folder_name.match(/[0-9]/)[0].to_i
			
			case opening_number
			when 1
				post_message = "OP曲ありがと⇄大丈夫のあいねちゃん"
			
			when 2
				post_message = "OP曲そこにしかないもののあいねちゃん"
			
			when 3
				post_message = "OP曲ひとりじゃない!のあいねちゃん"
			end


		when "fure_ending"

			ending_number = folder_name.match(/[0-9]/)[0].to_i

			case ending_number
			when 1
				post_message = "ED曲Believe itのあいねちゃん"
			
			when 2
				post_message = "ED曲プライドのあいねちゃん"
			
			when 3
				post_message = "ED曲Be starのあいねちゃん"
			end
		

		when "fure_dcd"

			post_message = "データカードダス アイカツフレンズ！のあいねちゃん"

		when "fure_eyecatch"

			eyecatch_number = folder_name.match(/[0-9]/)[0].to_i
			post_message 	= "#{eyecatch_number}期のアイキャッチのあいねちゃん"


		# On Parade

		when "onpa_dcd"

			post_message = "データカードダス アイカツオンパレード！のあいねちゃん"
			
		end

		return post_message

	end

	def post

		folder = @folder_list.sample(1)[0]
		media = get_media(folder)

		unless media.nil?
			
			post_message = get_post_message(folder.basename.to_s)
			# @client.update_with_media(post_message, media)
			
			if(media.is_a?(Array))
				@logger.info "Posted media folder #{folder.basename}"	
			else
				@logger.info "Posted media #{media.basename} from #{folder.basename}"	
			end
			
			@logger.info post_message	
		else
			@logger.info "Folder #{folder.basename} was empty!"	
		end
	
	end

	def get_stats

		table_rows 		= []
		total_files 	= 0
		total_images 	= 0
		total_gifs 		= 0
		total_videos 	= 0
		total_size 		= 0

		@folder_list.each do |folder|
			
			files = folder.children.select { |file| file.basename.to_s.chr() != "." }

			folder_images 	= 0
			folder_gifs 	= 0
			folder_videos 	= 0

			files.each do |file|

				case File.extname(file)

				when ".png"
				when ".jpg"
					folder_images += 1

				when ".gif"
					folder_gifs += 1

				when ".mp4"
					folder_videos += 1

				end

			end

			size = files.sum { |f| File.stat(f).blocks * 512 }
			
			total_images 	+= folder_images
			total_gifs 		+= folder_gifs
			total_videos 	+= folder_videos
			total_size 		+= size

			table_rows << [	folder.basename,
							folder_images,
							folder_gifs,
							folder_videos,
							files.count, 
							"#{(size.to_f / 1024 / 1024).round(2) } MB"]
			total_files += files.count
		end

		table = Terminal::Table.new do |t|
			t.title 	= 'Aine Bot Stats'
			t.headings 	= ['Category', 'Images', 'GIFs', 'Videos', 'File count', 'Size']
			t.rows 		= table_rows
			t 			<< :separator
			t 			<< ['Total',
							total_images,
							total_gifs,
							total_videos,
							total_files,
							"#{(total_size.to_f / 1024 / 1024 / 1024).round(2) } GB"]
		end

		out = 	table.to_s + "\n\n" +
				"fure = Friends\n" + 
				"onpa = On Parade" + 
				"\n\n" + Time.now.strftime("Last updated on %Y-%m-%d")

		return out

	end

	def media_path
		@media_path
	end

	def media_path=(media_path)
	  @media_path = media_path
	end

end