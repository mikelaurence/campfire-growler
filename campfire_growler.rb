require 'rubygems'
require 'ruby-growl'
require 'tinder'
include ActiveSupport::CoreExtensions::Array::Conversions

# Example use
#
# c = CampfireGrowler.new :account => 'mycampfire', 
#   :username => 'mklaurence@gmail.com', 
#   :password => 'password', 
#   :room => 'Room Of Champions'
# c.interval = 6
#
# Note:
# In your growl preferences, you *must* enable "Listen for incoming notifications"
# and "Allow remote application registration".

class CampfireGrowler
  
  attr_accessor :test_mode

  def initialize(options = {})  
    @account = options[:account]
    @campfire = Tinder::Campfire.new @account
    @campfire.login options[:username], options[:password]
    @room = @campfire.find_room_by_name options[:room]
    @users = []

    @growl = Growl.new "localhost", "ruby-growl", ["ruby-growl Notification"]
    
    @interval = options[:interval]
    @test_mode = options[:test_mode]
    
    unless options[:start] == false
      @interval ? loop_update : update
    end
  end
  
  def loop_update
    while
      update
      sleep @interval
    end
  end
  
  def update
    current_users = @room.users.collect { |u| u.match(/\>[\w\s]+\</) }.compact.collect { |u| u.to_s[1..-2] }
    notify current_users - @users, "in to"
    notify @users - current_users, "out of"
    puts "[#{header}] No change." if @test_mode and current_users == @users
  
    @users = current_users || []
  end
  
  def notify(users, phrase)
    if users and users.size > 0
      str = "#{users.to_sentence} #{users.size > 1 ? 'have' : 'has'} logged #{phrase} room #{@room.name}."
      if @test_mode
        puts "[#{header}] #{str}"
      else
        @growl.notify "ruby-growl Notification", "#{header}", str
      end
    end
  end
  
  def header
    "Campfire: #{@account}"
  end
  
end

