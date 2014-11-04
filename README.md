# Php-Serial

PHP serialization library.  Reads and writes PHP's serialization format.
Also has support for reading and writing PHP sessions.

## Installation

Add this line to your application's Gemfile:

    gem 'php-serial'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install php-serial

## Usage

This library provides 4 public methods:

Php.serialize

    Php.serialize ['string', 100]
    => "a:2:{i:0;s:6:\"string\";i:1;i:100;}"
Php.unserialize

    Php.unserialize "a:2:{i:0;s:6:\"string\";i:1;i:100;}"
    => ["string", 100]
Php.serialize_session

    Php.serialize_session {"var_a"=>"string", "var_b"=>3.14}
    => "var_a|s:6:\"string\";var_b|d:3.14"
Php.unserialize_session

    Php.unserialize_session "var_a|s:6:\"string\";var_b|d:3.14"
    => {"var_a"=>"string", "var_b"=>3.14}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
