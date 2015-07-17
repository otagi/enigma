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
      @rotors = options.delete(:rotors)
      @reflector = options.delete(:reflector)
      reset(options)
    end

    def reset(options = {})
      self.rotations = options.delete(:rotations)
      self.rings = options.delete(:rings)
    end

    def rotations=(rotations)
      @rotations = rotations || ''
      @rotors.each_with_index do |rotor, index|
        rotor.rotation = @rotations[index] || 'A'
      end
    end

    # Reset the rotors' rings.
    # The parameter is a string of A..Z chars:
    #   `rings = 'ABC'
    # or an array of ring positions (1..26):
    #   `rings = [1, 9, 26]`
    def rings=(rings)
      @rings = rings_to_s(rings) || ''
      @rotors.each_with_index do |rotor, index|
        rotor.ring = @rings[index] || 'A'
      end
    end

    def encode(message)
      message.chars.map { |c| encode_char(c) }.join
    end

    private

    def rings_to_s(rings)
      if rings.respond_to?(:map)
        rings = rings.map { |r| (r - 1 + 'A'.ord).chr }.join
      end
      rings
    end

    def encode_char(char)
      rotate_rotors

      # TODO: Plugboard encoding

      char = @rotors[2].encode(char)
      char = @rotors[1].encode(char)
      char = @rotors[0].encode(char)

      char = @reflector.encode(char)

      char = @rotors[0].decode(char)
      char = @rotors[1].decode(char)
      char = @rotors[2].decode(char)

      # TODO: Plugboard decoding

      char
    end

    def rotate_rotors
      @rotors[2].rotate
      @rotors[1].rotate if @rotors[2].turnover?
      @rotors[0].rotate if @rotors[1].turnover?
    end
  end
end