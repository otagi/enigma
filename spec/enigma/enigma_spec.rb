require 'spec_helper'

describe Enigma::Enigma do
  let(:enigma) { Enigma::Enigma.new }

  it 'creates a new Enigma machine with rotors and reflector' do
    enigma = Enigma::Enigma.new(
      rotors: [Enigma::RotorI.new, Enigma::RotorII.new, Enigma::RotorIII.new],
      reflector: Enigma::ReflectorB.new
    )
    expect(enigma.class).to eq Enigma::Enigma
    expect(enigma.rotors[0].class).to eq Enigma::RotorI
    expect(enigma.rotors[1].class).to eq Enigma::RotorII
    expect(enigma.rotors[2].class).to eq Enigma::RotorIII
    expect(enigma.reflector.class).to eq Enigma::ReflectorB
  end

  it 'creates a new Enigma machine with rotors and reflector strings' do
    enigma = Enigma::Enigma.new(rotors: %w(I II III), reflector: 'B')
    expect(enigma.class).to eq Enigma::Enigma
    expect(enigma.rotors[0].class).to eq Enigma::RotorI
    expect(enigma.rotors[1].class).to eq Enigma::RotorII
    expect(enigma.rotors[2].class).to eq Enigma::RotorIII
    expect(enigma.reflector.class).to eq Enigma::ReflectorB
  end

  context 'sample Enigma' do
    before do
      enigma.reset(
        rotors: %w(I II III),
        reflector: 'B'
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

    it 'encodes a message with rotations and rings set to AAA' do
      enigma.reset(rotations: 'AAA', rings: 'AAA')
      encoded_message = enigma.encode('AAAAA')
      expect(encoded_message).to eq 'BDZGO'
    end

    it 'encodes a message with rings set to BBB' do
      enigma.reset(rotations: 'AAA', rings: 'BBB')
      encoded_message = enigma.encode('AAAAA')
      expect(encoded_message).to eq 'EWTYX'
    end

    it 'encodes a message with rings set to 02 02 02' do
      enigma.reset(rotations: 'AAA', rings: [2, 2, 2])
      encoded_message = enigma.encode('AAAAA')
      expect(encoded_message).to eq 'EWTYX'
    end
  end

  # Settings and result from
  # http://www.enigmaworldcodegroup.com/#!create-an-enigma-message/c1lth
  context 'WCG Enigma' do
    before do
      enigma.reset(
        rotors: %w(III V II),
        reflector: 'B',
        rotations: 'TMK',
        rings: [8, 6, 23],
        plugboard: %w(BJ CY DX EZ FH GO LN MW QV TU)
      )
    end

    it 'encodes a message with the plugboard' do
      encoded_message = enigma.encode('MYDOG')
      expect(encoded_message).to eq 'CHESY'
    end

    it 'decodes a message with the plugboard' do
      encoded_message = enigma.decode('CHESY')
      expect(encoded_message).to eq 'MYDOG'
    end
  end

  # Settings and result from
  # http://operationturing.tumblr.com/post/120671980865
  # http://operationturing.tumblr.com/post/120819236115
  context 'Operation Turing (5 june 1940)' do
    before do
      enigma.reset(
        rotors: [Enigma::RotorII.new, Enigma::RotorIV.new, Enigma::RotorIII.new],
        reflector: Enigma::ReflectorB.new,
        rings: [16, 3, 10],
        plugboard: %w(AJ BH CI FV KU LW MZ NX OY PS)
      )
    end

    it 'decodes the message key' do
      enigma.rotations = 'HNS'
      message_key = enigma.decode('ALB')
      expect(message_key).to eq 'MTJ'
    end

    it 'decodes the message content' do
      enigma.rotations = 'MTJ'
      message = enigma.decode('BVGKY QPBWY WYOHR NVEBU RSQFF IYUTF FZZDB SEYUX OYVVW VXNEB MWSBY WOPSC CQUHI REHOA EMUFT UYYDT QFXPJ UMEHJ AXKZT TGTRR OKWSB EQLJK YOIGC SVIDA SQDYN DCQUS KEYQD BONJR')
      expect(message).to eq 'ITHAS BEENA MONTH SINCE OURLA STCOR RESPO NDENC EXIFY OUDON OTPAT CHMET HROUG HTOME NZIES NOWIM GOING TORES CUEBE STAND STEVE NSMYS ELFXI DONTC AREAB OUTTH ERISK XXXXX'
    end
  end
end
