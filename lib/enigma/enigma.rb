module Enigma
  # Enigma machine.
  #
  # Initialize it with 3 rotors (left to right) and 1 reflector:
  #   enigma = Enigma.new(
  #      rotors: [RotorI.new, RotorII.new, RotorIII.new],
  #      reflector: Reflector.new)
  #
  # Reset it with the rotors code and rings code:
  #   enigma.reset(rotations: 'AAA', rings: 'AAA')
  #
  # Encode a message:
  #   encoded_message = enigma.encode('AAAAA')
  #
  class Enigma
    attr_accessor :rotors, :reflector

    def initialize(options = {})
      @rotors    = []
      @reflector = nil
      @rotations = ''
      @rings     = ''
      @plugboard = {}
      reset(options)
    end

    def reset(options = {})
      options.each do |option, value|
        self.send("#{option}=", value) if self.respond_to?("#{option}=")
      end
    end

    # Set the rotors' rotations.
    # `rotations = 'ABC'` (one A..Z char per rotor)
    def rotations=(rotations)
      @rotations = rotations || ''
      @rotors.each_with_index do |rotor, index|
        rotor.rotation = @rotations[index] || 'A'
      end
    end

    # Set the rotors' rings.
    # `rings = 'ABC'` (one A..Z char per rotor) or
    # `rings = [1, 9, 26]` (one 1..26 number per rotor)
    def rings=(rings)
      @rings = rings_array_to_string(rings) || ''
      @rotors.each_with_index do |rotor, index|
        rotor.ring = @rings[index] || 'A'
      end
    end

    # Set the plugboard connections.
    # `plugboard = ['AE', 'CK', ...]` (one pair of chars for each connection)
    def plugboard=(plugboard)
      plugboard ||= []
      @plugboard = Hash[plugboard.map(&:chars)]
      @plugboard.merge! @plugboard.invert
    end

    # Make a char go through the plugboard.
    def plugboard(char)
      @plugboard[char] || char
    end

    # Encode a message through the plugboard, rotors, reflector, and back.
    def encode(message)
      cleaned_message = message.gsub(/[^A-Z]/, '')
      encoded_message = cleaned_message.chars.map { |c| encode_char(c) }.join
      chunked_message = encoded_message.scan(/.{1,5}/).join(' ')
    end

    alias_method :decode, :encode

    private

    def rings_array_to_string(rings)
      if rings.respond_to?(:map)
        rings = rings.map { |r| (r - 1 + 'A'.ord).chr }.join
      end
      rings
    end

    def encode_char(char)
      rotate_rotors

      char = plugboard(char)

      char = @rotors[2].encode(char)
      char = @rotors[1].encode(char)
      char = @rotors[0].encode(char)

      char = @reflector.encode(char)

      char = @rotors[0].decode(char)
      char = @rotors[1].decode(char)
      char = @rotors[2].decode(char)

      char = plugboard(char)

      char
    end

    def rotate_rotors
      @rotors[2].rotate
      @rotors[1].rotate if @rotors[2].turnover?
      @rotors[0].rotate if @rotors[1].turnover?
    end
  end
end