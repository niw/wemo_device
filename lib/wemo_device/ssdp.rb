require "socket"
require "timeout"
require "net/http"

module WemoDevice
  class SSDP
    MULTICAST_HOST = "239.255.255.250".freeze
    MULTICAST_PORT = 1900.freeze

    class Response
      def initialize(host, port, payload)
        @host = host
        @port = port
        @payload = payload
      end

      def search_target
        http_response["st"]
      end

      def unique_service_name
        http_response["usn"]
      end

      def location
        http_response["location"]
      end

      private

      def http_response
        @http_response ||= parse_http_response
      end

      def parse_http_response
        # Using Net::HTTPResponse private API to parse HTTP body from String.
        # See `net/http.rb`, `net/protocol.rb`, and `net/http/response.rb`.
        string_io = StringIO.new(@payload)
        buffered_io = Net::BufferedIO.new(string_io)
        Net::HTTPResponse.read_new(buffered_io)
      end
    end

    def lookup(search_target, timeout)
      UDPSocket.open do |socket|
        # `sendto(2)` should automatically `bind(2)`.
        socket.send(m_search_message(search_target), 0, MULTICAST_HOST, MULTICAST_PORT)

        responses = []
        begin
          Timeout.timeout(timeout) do
            loop do
              # `recv(2)` may discard excess bytes for message based sockets such as `SOCK_DGRAM`
              # when a message is too long and not fir in the given length and `MSG_PEEK` is not set.
              # Thus, the entire message shall be read in a single operation.
              payload, (_, port, host, _) = socket.recvfrom(4096)
              responses << Response.new(host, port, payload)
            end
          end
        rescue Timeout::Error
        end

        responses
      end
    end

    def m_search_message(search_target)
      [
        "M-SEARCH * HTTP/1.1",
        "Content-Length: 0",
        "ST: #{search_target}",
        # Device responses should be delayed a random duration between 0 and this many seconds
        # to balance load for the control point when it processes responses.
        "MX: 2",
        "MAN: \"ssdp:discover\"",
        "HOST: #{MULTICAST_HOST}:#{MULTICAST_PORT}",
        "",
        ""
      ].join("\r\n")
    end
  end
end
