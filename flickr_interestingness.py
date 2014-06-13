import xml.etree.ElementTree as ET
import urllib2
import re
import os

# remove current images
working_dir = os.path.dirname(os.path.realpath(__file__))

for root, dirs, files in os.walk(working_dir, topdown=False):
  for file in files:
    if os.path.splitext(file)[1].lower() in ('.jpg', '.jpeg'):
      # for 500px compatibility. 500px file does not contain '_'
      if '_' in file:
        full_path = os.path.join(root, file)
        # print os.path.join(root, file)
        os.remove(full_path)

# fetch rss
rss_url = 'http://feeds.feedburner.com/LargeFlickrInterestingnessFeedForWallpaper'
res = urllib2.urlopen(rss_url)
rss = res.read()

# fetch images
root = ET.XML(rss)

for item in root[0].iter('item'):
  link = item.find('link').text
  filename = re.split('\/', link)[-1]
  jpg = urllib2.urlopen(link)
  fh = open(working_dir + "/" + filename, 'w')
  fh.write(jpg.read())
  fh.close()
