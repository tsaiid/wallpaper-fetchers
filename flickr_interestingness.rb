require 'rss'
require 'yaml'
require 'open-uri'

# read config file
CONFIG_PATH = './config.yml'
cfg = YAML.load_file(CONFIG_PATH)
WORKING_DIR = ( cfg['working_dir'] && Dir.exists?(cfg['working_dir']) ? cfg['working_dir'] : Dir.pwd )

#CONSUMER_KEY = cfg['500px']['key']
#PHOTOS_PER_PAGE = cfg['500px']['photos_per_page']
RSS_URL = cfg['default']['flickr']['rss']['url']

# remove current images
## flickr photos contain '_'
Dir[WORKING_DIR + "/*.jpg"].select {|x| x =~ /_/}.each do |f|
  File.unlink(f)
end

# read RSS and fetch images
open(RSS_URL) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    filename = item.link.split('/')[-1]
    file_path = WORKING_DIR + "/" + filename

    # fetch image and write
    image = open(item.link).read
    File.open(file_path, 'w') do |f|
      f.write image
    end
  end
end