#!/usr/bin/env ruby

require "rubygems"
require "wemo_device"
require "optparse"

def set_wemo_switch_state(unique_service_name, state)
  device = WemoDevice::Device.lookup.find do |device|
    device.unique_service_name == unique_service_name
  end
  return false unless device

  uri = URI.parse(device.location)
  header = {
    "SOAPACTION" => '"urn:Belkin:service:basicevent:1#SetBinaryState"',
    "Content-Type" => "text/xml"
  }
  payload = <<-END_OF_XML
    <?xml version="1.0" encoding="utf-8"?>
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
    <s:Body>
    <u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1">
    <BinaryState>#{state ? 1 : 0}</BinaryState>
    </u:SetBinaryState>
    </s:Body>
    </s:Envelope>
  END_OF_XML

  Net::HTTP.start(uri.host, uri.port) do |http|
    case http.post("/upnp/control/basicevent1", payload, header)
    when Net::HTTPOK
      return true
    else
      return false
    end
  end
end

options = {}
option_parser = OptionParser.new do |opts|
  opts.on_tail("-u", "--usn=USN", "Wemo Switch unique service name") do |usn|
    options[:usn] = usn
  end
  opts.on_tail("--on", "Turn on the switch") do
    options[:action] = :on
  end
  opts.on_tail("--off", "Turn off the switch") do
    options[:action] = :off
  end
end
option_parser.parse!(ARGV)

raise "Missing unique service name" unless options[:usn]

case options[:action]
when :on
  set_wemo_switch_state(options[:usn], true)
when :off
  set_wemo_switch_state(options[:usn], false)
else
  raise "Missing action"
end
