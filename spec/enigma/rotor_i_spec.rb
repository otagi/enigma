require 'spec_helper'

describe Enigma::RotorI do
  let(:rotor) { Enigma::RotorI.new }

  it 'encodes a character' do
    char = rotor.encode 'A'
    expect(char).to eq 'E'
  end

  it 'decodes a character' do
    char = rotor.decode 'E'
    expect(char).to eq 'A'
  end

  it 'rotates' do
    char = rotor.rotate
    expect(char).to eq 'B'
  end

  it 'resets the rotation' do
    rotor.rotation = 'A'
    expect(rotor.rotation).to eq 'A'
  end

  context 'rotor notch is not current' do
    before do
      rotor.rotation = 'A'
    end

    it 'returns no turnover' do
      expect(rotor.turnover?).to eq false
    end
  end

  context 'rotor notch is current' do
    before do
      rotor.rotation = 'R'
    end

    it 'returns a turnover' do
      expect(rotor.turnover?).to eq true
    end
  end

  it 'cycles after the last char' do
    rotor.rotation = 'Z'
    rotor.rotate
    expect(rotor.rotation).to eq 'A'
  end

  context 'ring is set to B' do
    before do
      rotor.ring = 'B'
    end

    it 'encodes a character' do
      char = rotor.encode 'A'
      expect(char).to eq 'K'
    end
  end
end
