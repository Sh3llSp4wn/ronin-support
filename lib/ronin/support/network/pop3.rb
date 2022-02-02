#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

begin
  require 'net/pop'
rescue LoadError => error
  warn "ronin/network/pop3 requires the net-pop gem be listed in the Gemfile."
  raise(error)
end

module Ronin
  module Support
    module Network
      #
      # Provides helper methods for communicating with POP3 services.
      #
      module POP3
        # Default POP3 port
        DEFAULT_PORT = 110

        #
        # @return [Integer]
        #   The default Ronin POP3 port.
        #
        # @api public
        #
        def self.default_port
          @default_port ||= DEFAULT_PORT
        end

        #
        # Sets the default Ronin POP3 port.
        #
        # @param [Integer] port
        #   The new default Ronin POP3 port.
        #
        # @api public
        #
        def self.default_port=(port)
          @default_port = port
        end

        #
        # Creates a connection to the POP3 server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Integer] port
        #   The port the POP3 server is running on.
        #
        # @param [Boolean, Hash] ssl
        #   Additional SSL options.
        #
        # @option ssl [Boolean] :verify
        #   Specifies that the SSL certificate should be verified.
        #
        # @option ssl [String] :certs
        #   The path to the file containing CA certs of the server.
        #
        # @param [String] user
        #   The user to authenticate with when connecting to the POP3 server.
        #
        # @param [String] password
        #   The password to authenticate with when connecting to the POP3
        #   server.
        #
        # @yield [pop3]
        #   If a block is given, it will be passed the newly created POP3
        #   session.
        #
        # @yieldparam [Net::POP3] pop3
        #   The newly created POP3 session.
        #
        # @return [Net::POP3]
        #   The newly created POP3 session.
        #
        # @api public
        #
        def pop3_connect(host, port: POP3.default_port,
                               ssl:  nil,
                               user: ,
                               password: )
          host = host.to_s

          case ssl
          when Hash
            ssl        = true
            ssl_certs  = ssl[:certs]
            ssl_verify = SSL::VERIFY[ssl[:verify]]
          when TrueClass
            ssl        = true
            ssl_certs  = nil
            ssl_verify = nil
          else
            ssl        = false
            ssl_certs  = nil
            ssl_verify = false
          end

          pop3 = Net::POP3.new(host,port)
          pop3.enable_ssl(ssl_verify,ssl_certs) if ssl
          pop3.start(user,password)

          yield pop3 if block_given?
          return pop3
        end

        #
        # Starts a session with the POP3 server.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {#pop3_connect}.
        #
        # @yield [pop3]
        #   If a block is given, it will be passed the newly created POP3
        #   session. After the block has returned, the session will be closed.
        #
        # @yieldparam [Net::POP3] pop3
        #   The newly created POP3 session.
        #
        # @return [nil]
        #
        # @api public
        #
        def pop3_session(host,**kwargs)
          pop3 = pop3_connect(host,**kwargs)

          yield pop3 if block_given?

          pop3.finish
          return nil
        end
      end
    end
  end
end
