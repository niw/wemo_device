#!/usr/bin/env ruby

require "rubygems"
require "wemo_device"
require "pp"

WemoDevice::Device.lookup.each do |device|
  pp device
end
