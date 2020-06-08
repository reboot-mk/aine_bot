# Aine Bot
Twitter bot who posts pictures, videos, and GIFs of Yuuki Aine from the anime Aikatsu Friends.

## Installation

1. `$ git clone https://github.com/IrreversibleReboot/aine_bot.git`
2. `$ cd aine_bot`
3. `$ bundle install`
4. Edit the config.json.default accordingly.
5. `$ mv config.json.default config.json`
6. Optional: if you don't already a media folder set up, use `$ ./create_dir_structure.sh` to create one.

## Usage

Use `$ ruby bot.rb <command> <arguments>` or `$ ./bot.rb <command> <arguments>`.

## List of commands 

| Command  | Arguments | Description |
| ------------- | -------------  | ------------- |
| post  | -d, --dry: Don't actually post the image. | Post a random image from the storage path. |
| stats  | |  Print a stats table to STDOUT. |

## Media directory structure

The bot relies on the media directory's structure to choose which message to post along with the chosen picture. As such, it's important to respect it.

| Folder name  | Description |
| ------------- | ------------- |
| `fure_dcd`  | Data Cardass Aikatsu Friends! screenshots. |
| `fure_ep**`  |  Aikatsu Friends! episode screenshots. Goes from 01 to 76. |
| `fure_opening*`  | Aikatsu Friends! opening screenshots. Goes from 1 to 3. |
| `fure_ending*`  | Aikatsu Friends! ending screenshots. Goes from 1 to 3. |
| `onpa_dcd`  | Data Cardass Aikatsu On Parade! screenshots. |

Using `create_dir_structure.sh` will automatically generate this structure.
