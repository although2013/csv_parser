require "minitest/autorun"
require "./csv_record"

class TestMeme < Minitest::Test
  def setup
    Record.new('People')
    Record.new('Dog')
  end

  def test_name
    assert_equal "Zhang Kang", People.find('1').name
  end

  def test_dog
    assert_equal "a dog", Dog.find('1').name
  end

  def test_save
    howard = People.find('2')
    howard.name = 'Ge'
    assert_equal 'Howard', People.find('2').name
    howard.save
    assert_equal 'Ge', People.find('2').name
  end
end
