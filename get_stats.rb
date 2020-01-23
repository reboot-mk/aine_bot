require 'json'
require_relative "lib/aine_bot"

config = JSON.parse(File.read('config.json'))

bot = AineBot.new(config['media_path'], config['consumer_key'], config['consumer_secret'], config['access_token'], config['access_token_secret'])
puts bot.get_stats