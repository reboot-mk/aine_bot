require 'json'
require_relative "aine_bot"

config = JSON.parse(File.read('config.json'))

bot = AineBot.new(config['media_path'], config['consumer_key'], config['consumer_secret'], config['access_token'], config['access_token_secret'])
bot.post