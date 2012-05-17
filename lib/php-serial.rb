require "php-serial/version"

module Php
  # Serializes a ruby object into PHP serialized format
  #
  # Params:
  #   Mixed var
  # Returns: string
  def self.serialize(var)
    val = ''
    case var.class.to_s
      when 'NilClass'
        val = 'N;'
      when 'Fixnum'
        val = 'i:' + var.to_s + ';'
      when 'Float'
        val = 'd:' + var.to_s + ';'
      when 'TrueClass'
        val = 'b:1' + ';'
      when 'FalseClass'
        val = 'b:0' + ';'
      when 'String', 'Symbol'
        val = 's:' + var.length.to_s + ':' + '"' + var.to_s + '";'
      when 'Array'
        val = 'a:' + var.length.to_s + ':' + '{'
        var.length.times do |index|
          val += serialize(index) + serialize(var[index])
        end
        val += '}'
      when 'Hash'
        val = 'a:' + var.length.to_s + ':' + '{'
        var.each do |item_key, item_value|
          val += serialize(item_key) + serialize(item_value)
        end
        val += '}'
      else
        klass = var.class.to_s
        val = "O:#{klass.length.to_s}:\"#{klass}\":#{var.instance_variables.length}:{"
        var.instance_variables.each do |ivar|
          ivar = ivar.to_s
          ivar.slice!(0)
          val += serialize(ivar) + serialize(var.send(ivar))
        end
        val += '}'
    end
    val
  end

  # Serializes a hash into PHP session
  #
  # Params:
  #   Hash hash
  # Returns: string
  def self.serialize_session(hash)
    serialized_session = ''
    hash.each do |key,value|
      serialized_session += key.to_s + "|" + serialize(value)
    end
    serialized_session
  end

  # Unserializes a PHP session
  # 
  # Params:
  #   String data
  # Returns: hash
  def self.unserialize_session(data)
    data = data.chomp
    hash = {}
    
    while !data.empty? do
      key = extract_until!(data, "|")
      hash[key] = unserialize!(data)
    end
    hash
  end

  # Unserializes a string up to the first valid serialized instance
  # 
  # Params:
  #   String data
  # Returns: mixed
  def self.unserialize(data='')
    unserialize!(data.strip)
  end

  private

  # Unserializes recursively.  Consumes the input string.
  # 
  # Params:
  #   String data
  # Returns: mixed
  def self.unserialize!(data='')
    var_type = data.slice!(0)
    data.slice!(0)
    case var_type
      when "N"
        value = nil
      when "b"
        value = (extract_until!(data, ";") == '1')
      when "s"
        length = extract_until!(data, ":").to_i
        extract_until!(data, '"')
        value = data.slice!(0,length)
        extract_until!(data, ";")
      when "i"
        value = extract_until!(data, ";").to_i
      when "d"
        value = extract_until!(data, ";").to_f
      when "a"
        value = {}
        length = extract_until!(data, ":").to_i
        extract_until!(data, '{')
        length.times do
          key = unserialize!(data)
          value[key] = unserialize!(data)
        end
        extract_until!(data, "}")
        # if keys are sequential numbers, return array        
        value = value.values if Array(0..value.length-1) == value.keys and !value.empty?
      when "O"
        value = {}
        length = extract_until!(data, ":").to_i
        extract_until!(data, '"')
        value["class"] = data.slice!(0,length)
        extract_until!(data, ':')
        length = extract_until!(data, ":").to_i
        extract_until!(data, '{')
        length.times do
          key = unserialize!(data)
          value[key] = unserialize!(data)
        end
    end
    value
  end

  # Return all characters up to the first occurrence of char
  # Truncates those characters from input string
  # 
  # Params:
  #   String str
  #   String char
  # Returns: string
  def self.extract_until!(str, char)
    extracted = ''
    while (c = str.slice!(0))
      break if c == char
      extracted << c
    end
    extracted
  end
end