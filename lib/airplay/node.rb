require "airplay/playable"
require "airplay/viewable"
require "airplay/node/features"
require "airplay/node/info"

module Airplay
  # Public: Represents an Airplay Node
  #
  class Node
    attr_reader :name, :address, :password

    include Playable
    include Viewable

    def initialize(attributes = {})
      @name = attributes[:name]
      @address = attributes[:address]
      @password = attributes[:password]

      Airplay.configuration.load
    end

    def ip
      @_ip ||= address.split(":").first
    end

    def password=(passwd)
      @password = passwd
    end

    def password?
      !!password && !password.empty?
    end

    def features
      @_features ||= Features.new(self)
    end

    def info
      @_info ||= Info.new(self)
    end

    def server_info
      @_server_info ||= begin
        response = connection.get("/server-info").response
        plist = CFPropertyList::List.new(data: response.body)
        CFPropertyList.native_types(plist.value)
      end
    end

    private

    def connection
      @_connection ||= Airplay::Connection.new(self)
    end
  end
end
