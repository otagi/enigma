module Enigma
  # Abstract class for the rotors.
  class Rotor
    WIRES = '' # should be redefined in derived class with the output letters
    NOTCH = '' # should be redefined in derived class with the turnover letter

    def initialize
      input = 0..25
      output = self.class::WIRES.chars.map { |c| c.ord - 'A'.ord }
      @wires = Hash[input.zip(output)]
      @wires_inverted = @wires.invert
      @notch = self.class::NOTCH.ord - 'A'.ord unless self.class::NOTCH.empty?
      @rotation = 0
      @ring = 0
    end

    # Set the initial rotor offset.
    def rotation=(char = 'A')
      @rotation = char.ord - 'A'.ord
    end

    def rotation
      (@rotation + 'A'.ord).chr
    end

    # Set the initial ring offset.
    def ring=(char = 'A')
      @ring = char.ord - 'A'.ord
    end

    def ring
      (@ring + 'A'.ord).chr
    end

    # Rotate by 1 step.
    def rotate
      @rotation = (@rotation + 1) % 26
    end

    # Is it time to make the next rotor rotate?
    def turnover?
      @rotation == @notch
    end

    # Pass a char from the right of the rotor to the left.
    def encode(char)
      contact_in   = char_to_contact(char)
      contact_out  = @wires[contact_in]
      encoded_char = contact_to_char(contact_out)
    end

    # Pass a char from the left of the rotor to the right.
    def decode(char)
      contact_in   = char_to_contact(char)
      contact_out  = @wires_inverted[contact_in]
      decoded_char = contact_to_char(contact_out)
    end

    private

    def char_to_contact(char)
      contact         = char.ord - 'A'.ord
      rotated_contact = (contact + @rotation - @ring) % 26
    end

    def contact_to_char(rotated_contact)
      contact = (rotated_contact - @rotation + @ring) % 26
      char    = (contact + 'A'.ord).chr
    end
  end
end