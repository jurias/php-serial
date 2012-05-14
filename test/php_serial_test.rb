require 'test_helper'

describe 'Serialize' do
  it 'should correctly serialize strings' do
    input = "This is a string"
    expected = 's:16:"This is a string";'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize symbols' do
    input = "This is a symbol"
    expected = 's:16:"This is a symbol";'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize integers' do
    input = 20
    expected = 'i:20;'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize floats' do
    input = 3.14159
    expected = 'd:3.14159;'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize booleans' do
    input = false
    expected = 'b:0;'
    Php.serialize(input).must_equal expected

    input = true
    expected = 'b:1;'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize nil' do
    input = nil
    expected = 'N;'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize arrays' do
    input = [1,2,3,4,5]
    expected = 'a:5:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;}'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize hashes' do
    input = {a: 1, b: "string", c: nil, d: true, e: 3.14159}
    expected = 'a:5:{s:1:"a";i:1;s:1:"b";s:6:"string";s:1:"c";N;s:1:"d";b:1;s:1:"e";d:3.14159;}'
    Php.serialize(input).must_equal expected
  end

  it 'should correctly serialize arbitrary class objects' do
    class Person
      attr_accessor :first_name, :last_name
    end
    person = Person.new
    person.first_name = 'John'
    person.last_name = 'Doe'

    input = person
    expected = 'O:6:"Person":2:{s:10:"first_name";s:4:"John";s:9:"last_name";s:3:"Doe";}'
    Php.serialize(input).must_equal expected
  end
end


describe 'Unserialize' do
  it 'should correctly unserialize strings' do
    input = 's:16:"This is a string";'
    expected = "This is a string"
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize symbols' do
    input = 's:16:"This is a symbol";'
    expected = "This is a symbol"
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize integers' do
    input = 'i:20;'
    expected = 20
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize floats' do
    input = 'd:3.14159;'
    expected = 3.14159
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize booleans' do
    input = 'b:0;'
    expected = false
    Php.unserialize(input).must_equal expected

    input = 'b:1;'
    expected = true
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize nil' do
    input = 'N;'
    expected = nil
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize arrays' do
    input = 'a:5:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;}'
    expected = [1,2,3,4,5]
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize hashes' do
    input = 'a:5:{s:1:"a";i:1;s:1:"b";s:6:"string";s:1:"c";N;s:1:"d";b:1;s:1:"e";d:3.14159;}'
    expected = {"a" => 1, "b" => "string", "c" => nil, "d" => true, "e" => 3.14159}
    Php.unserialize(input).must_equal expected
  end

  it 'should correctly unserialize objects' do
    input = 'O:6:"Person":2:{s:10:"first_name";s:4:"John";s:9:"last_name";s:3:"Doe";}'
    expected = {"class" => "Person", "first_name" => "John", "last_name" => "Doe"}
    Php.unserialize(input).must_equal expected
  end
end


describe 'Serialize Session' do
  it 'should correctly serialize a hash into a php session' do
    input = {"a" => 1, "b" => "string", "c" => nil, "d" => true, "e" => 3.14159}
    expected = 'a|i:1;b|s:6:"string";c|N;d|b:1;e|d:3.14159;'
    Php.serialize_session(input).must_equal expected
  end

  it 'should correctly serialize a complex hash into a php session' do
    input = {
      "complex/key/A" => "A'A\";|$",
      "complex/key/B" => [1,2,3,4,5,6,7,8,{},10],
      "complex/key/C" => nil,
      "complex/key/D" => {one: 1, "two" => "Two"},
      "complex/key/E" => {index:{index:{index:{}}}}
    }
    expected = 'complex/key/A|s:7:"A\'A";|$";complex/key/B|a:10:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:8;i:8;a:0:{}i:9;i:10;}complex/key/C|N;complex/key/D|a:2:{s:3:"one";i:1;s:3:"two";s:3:"Two";}complex/key/E|a:1:{s:5:"index";a:1:{s:5:"index";a:1:{s:5:"index";a:0:{}}}}'
    Php.serialize_session(input).must_equal expected
  end
end

describe 'Unserialize Session' do
  it 'should correctly unserialize a php session into a hash' do
    input = 'a|i:1;b|s:6:"string";c|N;d|b:1;e|d:3.14159;'
    expected = {"a" => 1, "b" => "string", "c" => nil, "d" => true, "e" => 3.14159}
    Php.unserialize_session(input).must_equal expected
  end

  it 'should correctly unserialize a complex php session' do
    input = 'complex/key/A|s:7:"A\'A";|$";complex/key/B|a:10:{i:0;i:1;i:1;i:2;i:2;i:3;i:3;i:4;i:4;i:5;i:5;i:6;i:6;i:7;i:7;i:8;i:8;a:0:{}i:9;i:10;}complex/key/C|N;complex/key/D|a:2:{s:3:"one";i:1;s:3:"two";s:3:"Two";}complex/key/E|a:1:{s:5:"index";a:1:{s:5:"index";a:1:{s:5:"index";a:0:{}}}}'
    expected = {
      "complex/key/A" => "A'A\";|$",
      "complex/key/B" => [1,2,3,4,5,6,7,8,{},10],
      "complex/key/C" => nil,
      "complex/key/D" => {"one" => 1, "two" => "Two"},
      "complex/key/E" => {"index" => {"index" => {"index" => {}}}}
    }
    Php.unserialize_session(input).must_equal expected
  end
end