require 'twitter'
require 'awesome_print'
require "json"

module Twitter
  class Analyzer
    attr_accessor :client

    def initialize *options
      configure *options
    end

    def compare user1, user2
      puts "#{load(user1).count} followers for #{user1}"
      puts "#{load(user2).count} followers for #{user2}"
      diff(user1, user2)
      diff(user2, user1)
      nil
    end

    private

    def load username
      filename = ".cache/#{username}.json"
      if File.exists?(filename)
        JSON.parse(File.read(filename))
      else
        Dir.mkdir(".cache") unless File.exists?(".cache")
        ids = friends_ids_for(username)
        File.open(filename, 'w') { |file| file.write(ids.to_json) }
        ids
      end
    end

    def friends_ids_for username
      follower_ids = []
      next_cursor = -1
      while next_cursor != 0
        cursor = Twitter.follower_ids(username, cursor: next_cursor)
        follower_ids.concat cursor.collection
        next_cursor = cursor.next_cursor
      end
      follower_ids
    end

    def diff user1, user2
      count = (load(user1) - load(user2)).count
      percentage = ((count.to_f / load(user1).count.to_f)*100).round(2)
      puts "#{count} followers for #{user1} that are not shared by #{user2} (#{percentage}%)"
    end

    def configure consumer_key, consumer_secret, access_token, access_secret
      Twitter.configure do |config|
        config.consumer_key = consumer_key
        config.consumer_secret = consumer_secret
        config.oauth_token = access_token
        config.oauth_token_secret = access_secret
      end
    end
  end
end