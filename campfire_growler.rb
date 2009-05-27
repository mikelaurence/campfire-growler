require 'rubygems'
require 'ruby-growl'
require 'tinder'
include ActiveSupport::CoreExtensions::Array::Conversions

class CampfireGrowler
  
  attr_accessor :test_mode

  def initialize(params = {})
    @test_mode = params[:test_mode]
    @account = params[:account]
    @campfire = Tinder::Campfire.new @account
    @campfire.login params[:username], params[:password]
    @room = @campfire.find_room_by_name params[:room]
    @users = []
    
    @growl = Growl.new "localhost", "ruby-growl", [growl_name]
    
    interval = params[:interval] if params[:interval]
  end
  
  def interval=(seconds)
    while
      current_users = @room.users.collect { |u| u.match(/\>[\w\s]+\</) }.compact.collect { |u| u.to_s[1..-2] }
      notify current_users - @users, "in to"
      notify @users - current_users, "out of"
      puts "#{prefix} No change." if @test_mode and current_users == @users
    
      @users = current_users || []
      sleep seconds
    end
  end
  
  def notify(users, phrase)
    if users and users.size > 0
      str = "#{prefix} #{users.to_sentence} #{users.size > 1 ? 'have' : 'has'} logged #{phrase} room #{@room.name}."
      if @test_mode
        puts str
      else
        @growl.notify growl_name, "Check your posture, fool.", "Translation: SIT UP!"
      end
    end
  end
  
  def prefix
    "[Campfire: #{@account}]"
  end
  
  def growl_name
    "#{prefix} #{@room.name} Notification"
  end
  
end

