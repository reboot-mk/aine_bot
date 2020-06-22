#!/bin/ruby

require 'yaml'
require_relative "lib/aine_bot"

BotPath = File.expand_path File.dirname(__FILE__)
config 	= YAML.load(File.read(File.join(BotPath, 'config.json')))

config['bot_path'] = BotPath

bot = AineBot.new(config)

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