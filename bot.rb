#!/bin/ruby

require 'json'
require_relative "lib/aine_bot"

BOT_PATH=File.expand_path File.dirname(__FILE__)

config = JSON.parse(File.read(File.join(BOT_PATH, 'config.json')))

bot = AineBot.new(BOT_PATH, config['storage_path'], config['consumer_key'], config['consumer_secret'], config['access_token'], config['access_token_secret'])

unless !ARGV[0]

	case ARGV[0]
			
		when "post"
				
			if(ARGV[1] == "-d" || ARGV[1] == "--dry")
				bot.post(true)
			else
				bot.post(false)
			end

		when "stats"
			stats = bot.get_stats
			puts bot.print_stats(stats)
		
		else
			puts "Unknown command"
	end
		
else
	puts "Missing command"
end