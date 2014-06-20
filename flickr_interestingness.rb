require 'rss'
require 'yaml'
require 'json'
require 'open-uri'

# read config file
CONFIG_PATH = './config.yml'
cfg = YAML.load_file(CONFIG_PATH)
WORKING_DIR = ( cfg['working_dir'] && Dir.exists?(cfg['working_dir']) ? cfg['working_dir'] : Dir.pwd )

api_fi_url = "https://api.flickr.com/services/rest/?" +
             "method=flickr.interestingness.getList&" +
             "format=json&" +
             "nojsoncallback=1&" +
             "api_key=" + cfg['flickr']['key']

# remove current images
## flickr photos contain '_'
Dir[WORKING_DIR + "/*.jpg"].select {|x| x =~ /_/}.each do |f|
  File.unlink(f)
end

# read RSS and fetch images
#open(RSS_URL) do |rss|
rsp = JSON.load(open(api_fi_url))
if rsp['stat'] == 'ok'
  rsp['photos']['photo'].each do |photo|
    api_psize_url = "https://api.flickr.com/services/rest/?" +
                    "method=flickr.photos.getSizes&" +
                    "format=json&" +
                    "nojsoncallback=1&" +
                    "api_key=" + cfg['flickr']['key'] + "&" +
                    "photo_id=" + photo['id']
    rsp_sizes = JSON.load(open(api_psize_url))
    if rsp_sizes['stat'] == 'ok'
      largest = rsp_sizes['sizes']['size'][-1]
      if [largest['width'].to_i, largest['height'].to_i].max >= 1920
        filename = largest['source'].split('/')[-1]
        file_path = WORKING_DIR + "/" + filename

        # fetch image and write
        File.open(file_path, 'w') do |f|
          f.write open(largest['source']).read
        end
      end
    end
  end
end