# Aine Bot
Twitter bot who posts pictures of Yuuki Aine from the anime Aikatsu Friends.

## Installation

1. `$ git clone https://github.com/IrreversibleReboot/aine_bot.git`
2. `$ cd aine_bot`
3. `$ bundle install`
4. Edit the config.json.default accordingly.
5. `$ mv config.json.default config.json`

## Usage

Use `$ ruby post.rb` to post a random image.

Use something like crontab to run this command every hour or so. 

## Media directory structure

The bot relies on the media directory's structure to choose which message to post along with the chosen picture. As such, it's important to respect it.

| Folder name  | Description |
| ------------- | ------------- |
| `dcd_friends`  | Data Cardass Aikatsu Friends! screenshots. |
| `dcd_onpa`  | Data Cardass Aikatsu On Parade! screenshots. |
| `episode_**`  | Episode screenshots. Goes from 01 to 76. |
| `opening_*`  | Opening screenshots. Goes from 1 to 3. |
| `ending_*`  | Ending screenshots. Goes from 1 to 3. |
