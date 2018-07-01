require "rexml/document"

module WemoDevice
  URN = "urn:Belkin:service:basicevent:1".freeze

  class Device
    class << self
      def lookup
        # Wemo devices are responding only when search target is the URN.
        # `ssdp:all` and other search target doesn't work.
        SSDP.new.lookup(URN, 3).select do |response|
          # There are many devices that ignores `ST`, like Philips Hue.
          response.search_target == URN
        end.map do |response|
          Device.new(response)
        end
      end
    end

    def initialize(response)
      @response = response
    end

    def unique_service_name
      @response.unique_service_name
    end

    def location
      @response.location
    end
  end
end
