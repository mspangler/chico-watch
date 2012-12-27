#!/usr/bin/env ruby

require File.expand_path("../chico.rb", __FILE__)

require 'rubygems'
require 'dante'
require 'pubnub'

class ChicoWatch

  # Start subscribing to the dog channel
  def initialize
    pubnub = Pubnub.new(:subscribe_key => 'sub-c6a6acee-4672-11e0-af21-13b052347a9b')
    pubnub.subscribe(:channel => :dog_channel,
                     :callback => lambda { |message| handle(message) })
  end

  # Parse the message received from the video monitor
  # message example: [[{"command":"couch"}],"13565581135598040"]
  def handle(message)
    json = message[0][0]
    if !json.blank?
      process(json['command'])
    end
  end

  # Process the command
  def process(command)
    puts "Received command #{command}"

    # Play an mp3 based on the command
    case command
    when 'couch'
      play "test.mp3"
    when 'horse_playing'
      play "Chico! Stop It!.mp3"
    end
  end

  # Play audio through connected speakers
  def play(audio)
    IO.popen("afplay #{audio} &")
  end

end

# How to run: ./chico.rb -d -P chico.pid -l chico.log
# How to kill: ./chico.rb -k -P chico.pid
# Help: ./chico.rb --help
Dante.run('chico_watch') do |opt|
  ChicoWatch.new
end
