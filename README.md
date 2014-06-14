Wallpaper Fetchers
==================

## Introduction

This project includes two Ruby scripts to fetch Flickr Interestingness and 500px Popular images. The source of flickr interestingness is based on [a RSS feed built with Yahoo Pipes][fi-yp-rss], and the 500px one fetches image using official 500px API, which offers popular images.

## Requirement

A gem `image_size` is required for accessing the fetched image size. You can install it with:

```
gem install image_size
```

## Settings

1. Copy the `config-example.yml` to `config.yml` for further settings.
2. You can set a working directory to save the wallpaper images. The default is current directory `'.'`.
3. Using 500px fetcher, you need a API key. You can register one at [500px / Developer][500px-dev]. Besides, you can set the number of photo getting in `config.yml`. The maximum number is `100`.

[fi-yp-rss]:	http://pipes.yahoo.com/pipes/pipe.info?_id=674e63729ed98e27dd88aadb70b85cf0
[500px-dev]:	http://developers.500px.com/
