require 'json'
require 'yaml'
require 'open-uri'
require 'image_size'

# read config file
CONFIG_PATH = './config.yml'
cfg = YAML.load_file(CONFIG_PATH)
WORKING_DIR = ( cfg['working_dir'] && Dir.exists?(cfg['working_dir']) ? cfg['working_dir'] : Dir.pwd )

CONSUMER_KEY = cfg['500px']['key']
PHOTOS_PER_PAGE = cfg['500px']['photos_per_page']
BASE_URL = cfg['default']['500px']['base_url']

POPULAR_URL = BASE_URL + '/v1/photos?' +
              'consumer_key=' + CONSUMER_KEY + '&' +
              'feature=popular' + '&' +
              'image_size=4' + '&' +
              'sort=created_at' + '&' +
              'rpp=' + PHOTOS_PER_PAGE.to_s

# remove current images
## flickr photos contain '_'
Dir[WORKING_DIR + "/*.jpg"].select {|x| x =~ /^[^_]+$/}.each do |f|
  File.unlink(f)
end

# read RSS and fetch images
JSON.load(open(POPULAR_URL))['photos'].each do |photo|
  image_url = photo['image_url'].gsub(/4\.jpg/, '2048.jpg')
  filename = WORKING_DIR + '/' + photo['image_url'].match(/\/([^\/]+)\/4\.jpg/)[1] + '.jpg'

  # fetch image and write
  image = open(image_url).read
  max_size = ImageSize.new(image).size.max
  if (max_size >= 1920)
    File.open(filename, 'w') do |fo|
      fo.write image
    end
  end
end
