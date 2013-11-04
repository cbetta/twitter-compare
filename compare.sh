#!/usr/bin/env ruby

require "yaml"
require_relative "twitter/analyzer"

if ARGV[0] == "clear"
  `rm -f .cache/*`
else
  config = YAML::load( File.open('config.yml') )
  Twitter::Analyzer.new(config["TWITTER_CLIENT_ID"],config["TWITTER_CLIENT_SECRET"],config["TWITTER_ACCESS_TOKEN"],config["TWITTER_ACCESS_SECRET"]).compare(config["USERNAME1"], config["USERNAME2"])
end
