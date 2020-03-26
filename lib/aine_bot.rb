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

		@logger = Logger.new('bot.log')

		@media_list = []
		folder_list = Pathname.new(@media_path).children.sort.select { |c| c.directory? }
		folder_list.each do |folder|

			folder = Pathname.new(folder)

			# Eyecatches are added as a single entry in the file list, because the bot should
			# always post two images

			unless folder.basename.to_s.include?("eyecatch")

				files = folder.children.select { |file| file.basename.to_s.chr() != "." }

				files.each do |file|
					file = Pathname.new(file)
					@media_list.push(file)
				end

			else
				@media_list.push(folder)
			end

		end

	end

	def pick_media

		type_picker = rand()

		case

		when type_picker < 0.15
			
			pick_list = @media_list.select do |entry| 
				if (File.extname(entry) == ".gif" || File.extname(entry) == ".mp4")
					true
				else
					false
				end
			end

		when type_picker < 1

			pick_list = @media_list.select do |entry| 
				if (File.extname(entry) == ".jpg" || File.extname(entry) == ".png") || entry.directory?
					true
				else
					false
				end
			end

		end

		return pick_list.sample(1)[0]

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

		media = pick_media()

		unless media.nil?
			
			if(media.directory?)
				post_message = get_post_message(media.basename.to_s)
			else
				post_message = get_post_message(media.parent.basename.to_s)
			end

			@client.update_with_media(post_message, media)
			
			if(media.directory?)
				@logger.info "Posted media folder #{media.basename}"	
			else
				@logger.info "Posted media #{media.basename} from #{media.parent.basename}"	
			end
			
			@logger.info post_message	

		end
	
	end

	def get_stats

		# Gathering data

		media_stats = Hash.new
		totals 		= Hash.new(0)
		@media_list.each do |entry|

			unless entry.directory?

				key = entry.parent.basename.to_s
				media_stats.key?(key) ? (stats = media_stats[key]) : (stats = Hash.new(0))

				stats[:files] 	+= 1
				stats[:size] 	+= File.stat(entry).blocks * 512 
				totals[:files] 	+= 1
				totals[:size] 	+= File.stat(entry).blocks * 512 

				case File.extname(entry)

				when ".png"
				when ".jpg"
					stats[:img] 	+= 1
					totals[:img] 	+= 1

				when ".gif"
					stats[:gif] 	+= 1
					totals[:gif] 	+= 1

				when ".mp4"
					stats[:vid] 	+= 1
					totals[:vid] 	+= 1
				end


			else

				key = entry.basename.to_s
				media_stats.key?(key) ? (stats = media_stats[key]) : (stats = Hash.new(0))

				child_files = entry.children.select { |file| file.basename.to_s.chr() != "." }

				child_files.each do |file|

					stats[:files] 	+= 1
					stats[:size] 	+= File.stat(file).blocks * 512 
					totals[:files] 	+= 1
					totals[:size] 	+= File.stat(file).blocks * 512 

					case File.extname(file)

					when ".png"
					when ".jpg"
						stats[:img] 	+= 1
						totals[:img] 	+= 1

					when ".gif"
						stats[:gif] 	+= 1
						totals[:gif] 	+= 1

					when ".mp4"
						stats[:vid] 	+= 1
						totals[:vid] 	+= 1
					end

				end

			end

			media_stats[key] = stats

		end

		# Generating table

		table_rows = []

		media_stats.each do |name, stats|

			table_rows << [	name,
							stats[:img],
							stats[:gif],
							stats[:vid],
							stats[:files],
							"#{(stats[:size].to_f / 1024 / 1024).round(2) } MB"
			]

		end

		table = Terminal::Table.new do |t|
			t.title 	= 'Aine Bot Stats'
			t.headings 	= ['Category', 'Images', 'GIFs', 'Videos', 'File count', 'Size']
			t.rows 		= table_rows
			t 			<< :separator
			t 			<< [
								'Total', 
								totals[:img],
								totals[:gif],
								totals[:vid],
								totals[:files], 
								"#{(totals[:size].to_f / 1024 / 1024 / 1024).round(2) } GB"
						   ]
		end

		out = 	table.to_s + "\n\n" +
				"fure = Friends\n" + 
				"onpa = On Parade" + 
				"\n\n" + Time.now.strftime("Last updated on %Y-%m-%d")

		return out


	end

end