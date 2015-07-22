require 'spec_helper'

describe Enigma::Enigma do
  let(:enigma) do
    Enigma::Enigma.new(
      rotors: [Enigma::RotorI.new, Enigma::RotorII.new, Enigma::RotorIII.new],
      reflector: Enigma::ReflectorB.new
    )
  end

  it 'resets the rotors' do
    enigma.reset(rotations: 'BCD', rings: 'EFG')
    expect(enigma.rotors[0].rotation).to eq 'B'
    expect(enigma.rotors[1].rotation).to eq 'C'
    expect(enigma.rotors[2].rotation).to eq 'D'
    expect(enigma.rotors[0].ring).to eq 'E'
    expect(enigma.rotors[1].ring).to eq 'F'
    expect(enigma.rotors[2].ring).to eq 'G'
  end

  it 'resets the rotors with rings numerals' do
    enigma.reset(rings: [5, 6, 7])
    expect(enigma.rotors[0].ring).to eq 'E'
    expect(enigma.rotors[1].ring).to eq 'F'
    expect(enigma.rotors[2].ring).to eq 'G'
  end

  it 'resets the plugboard' do
    enigma.reset(plugboard: %w(AV BS CG DL FU HZ IN KM OW RX))
    expect(enigma.plugboard('A')).to eq 'V'
    expect(enigma.plugboard('V')).to eq 'A'
    expect(enigma.plugboard('E')).to eq 'E'
  end

  context 'rotations and rings set to AAA' do
    before do
      enigma.reset(rotations: 'AAA', rings: 'AAA')
    end

    it 'encodes a message' do
      encoded_message = enigma.encode('AAAAA')
      expect(encoded_message).to eq 'BDZGO'
    end
  end

  context 'rings set to BBB' do
    before do
      enigma.reset(rotations: 'AAA', rings: 'BBB')
    end

    it 'encodes a message' do
      encoded_message = enigma.encode('AAAAA')
      expect(encoded_message).to eq 'EWTYX'
    end
  end

  context 'rings set to 02 02 02' do
    before do
      enigma.reset(rotations: 'AAA', rings: [2, 2, 2])
    end

    it 'encodes a message' do
      encoded_message = enigma.encode('AAAAA')
      expect(encoded_message).to eq 'EWTYX'
    end
  end

  context 'long message' do
    before do
      enigma.reset(
        rotors: [Enigma::RotorII.new, Enigma::RotorI.new, Enigma::RotorV.new],
        rotations: 'FRA',
        rings: 'AAA',
        plugboard: %w(AB IR UX KP)
      )
    end

    # TODO: Find a good example to test encoding with the plugboard.
    # it 'encodes a long message' do
    #   encoded_message = enigma.encode('ANBULMEGRAZGOESTINGSTRENGGEHEIMEMELDUNG')
    #   expect(encoded_message).to eq 'PCDAONONEBCJBOGLYMEEYGSHRYUBUJHMJOQZLEX'
    # end
  end
end
