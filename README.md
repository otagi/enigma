# Enigma

A Ruby implementation of the [Enigma machine](https://en.wikipedia.org/wiki/Enigma_machine).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enigma'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enigma

## Usage

### Basic example:

```ruby
# 1. Instantiate an Enigma machine:
enigma = Enigma::Enigma.new(
  rotors: [Enigma::RotorI.new, Enigma::RotorII.new, Enigma::RotorIII.new],
  reflector: Enigma::ReflectorB.new,
  rotations: 'AAA',
  rings: 'AAA',
  plugboard: %w(AB IR UX KP)
)

# 2. Encode / decode the message:
encoded_message = enigma.encode('AAAAA')
```

You can also set any parameter with `reset`:

```ruby
enigma.reset(rotations: 'AAA', rings: 'AAA')
```

or through the accessors:

```ruby
enigma.rotations = 'AAA'
```

### Parameters:

- **rotors**
	
	An array of Rotor objects.
	
	Set from left to right.
	
	RotorI, II, III, IV and V are available.

- **reflector**
	
	A Reflector object.
	
	ReflectorB is the only one available.

- **rotations**
	
	A string of upcase A..Z chars. One for each rotor. (defaults to 'A')
	
	Sets the initial rotation of each rotor. (i.e. it's the message key code)

- **rings**
	
	A string of upcase A..Z chars. One for each rotor. (defaults to 'A')
	
	Or an array of 1..26 numbers. One for each rotor.
	
	Sets the ring position of each rotor.

- **plugboard**
	
	An array of upcase 2-char strings. One string for each connected letter pair. (defaults to all letters mapping to themselves)

	Sets the connections on the plugboard.

## Todo

Test the encoding with real-world parameters and messages.

Add more Enigma models, rotors and reflectors.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/otagi/enigma/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
