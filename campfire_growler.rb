require 'rubygems'
require 'ruby-growl'
require 'tinder'
include ActiveSupport::CoreExtensions::Array::Conversions

# Example use
#
# c = CampfireGrowler.new :account => 'mycampfire', 
#   :username => 'mklaurence@gmail.com', 
#   :password => 'password', 
#   :room => 'Room Of Champions', 
#   :test_mode => false
# c.interval = 6
#

class CampfireGrowler
  
  attr_accessor :test_mode

  def initialize(params = {})
    @test_mode = params[:test_mode]
    @account = params[:account]
    @campfire = Tinder::Campfire.new @account
    @campfire.login params[:username], params[:password]
    @room = @campfire.find_room_by_name params[:room]
    @users = []

    @growl = Growl.new "localhost", "ruby-growl", ["ruby-growl Notification"]
    
    interval = params[:interval] if params[:interval]
  end
  
  def interval=(seconds)
    while
      current_users = @room.users.collect { |u| u.match(/\>[\w\s]+\</) }.compact.collect { |u| u.to_s[1..-2] }
      notify current_users - @users, "in to"
      notify @users - current_users, "out of"
      puts "[#{header}] No change." if @test_mode and current_users == @users
    
      @users = current_users || []
      sleep seconds
    end
  end
  
  def notify(users, phrase)
    if users and users.size > 0
      str = "#{users.to_sentence} #{users.size > 1 ? 'have' : 'has'} logged #{phrase} room #{@room.name}."
      if @test_mode
        puts "[#{header}] #{str}"
      else
        puts "trying"
        @growl.notify "ruby-growl Notification", "#{header}", str
      end
    end
  end
  
  def header
    "Campfire: #{@account}"
  end
  
end

