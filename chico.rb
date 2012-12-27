#!/usr/bin/env ruby

require File.expand_path('../chico.rb', __FILE__)

require 'rubygems'
require 'dante'
require 'pubnub'

class ChicoWatch

  # Start subscribing to the dog channel
  def initialize
    pubnub = Pubnub.new(:subscribe_key => 'sub-c6a6acee-4672-11e0-af21-13b052347a9b')
    pubnub.subscribe(:channel => :dog_channel, :callback => lambda { |message| parse(message) })
  end

  # Parse the message received from the video monitor
  # message example: [[{"command":"couch"}],"13565581135598040"]
  def parse(message)
    json = message[0][0]
    play(json['command'], message[1]) unless json.blank?
  end

  # Play audio through connected speakers
  def play(command, time_token)
    puts "Received command '#{command}' at #{time_token}"
    IO.popen("afplay audio/#{command}.m4a &")
  end

end

# How to run: ./chico.rb -d -P chico.pid -l chico.log
# How to kill: ./chico.rb -k -P chico.pid
# Help: ./chico.rb --help
Dante.run('chico_watch') do |opt|
  ChicoWatch.new
end
