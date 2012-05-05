#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/binary/template'

class Float

  #
  # Packs the Float into a String.
  #
  # @param [String, Symbol] argument
  #   The `Array#pack` String code or {Binary::Template} type.
  #
  # @return [String]
  #   The packed float.
  #
  # @raise [ArgumentError]
  #   The argument was not an `Array#pack` String code or {Binary::Template}
  #   type.
  #
  # @example using `Array#pack` codes:
  #   0.42.pack('F')
  #   # => =\n\xD7>"
  #
  # @example using {Binary::Template} types:
  #   0x42.pack(:float_be)
  #   # => ">\xD7\n="
  #
  # @see http://ruby-doc.org/core/classes/Array.html#M002222
  #
  # @since 0.5.0
  #
  # @api public
  #
  def pack(argument)
    case argument
    when String
      [self].pack(argument)
    when Symbol
      Ronin::Binary::Template.new(argument).pack(self)
    else
      raise(ArgumentError,"argument must be a String or a Symbol")
    end
  end

end
