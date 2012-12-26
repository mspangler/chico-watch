#!/usr/bin/env ruby

require File.expand_path("../chico.rb", __FILE__)

require 'rubygems'
require 'dante'
require 'pubnub'

class ChicoWatch

  def initialize
    pubnub = Pubnub.new(:subscribe_key => 'secret')
    pubnub.subscribe(:channel => :my_channel,
                     :callback => lambda { |message| handle(message) })
  end

  def handle(message)
    #  example of the format of the message: [[{"command":"couch"}],"13565581135598040"]
    json = message[0][0]
    if !json.blank?
      process(json['command'])
    end
  end

  def process(command)
    puts "Received command #{command}"
  end

end

Dante.run('chico_watch') do |opt|
  ChicoWatch.new
end
