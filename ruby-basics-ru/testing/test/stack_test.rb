# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def setup
    @stack = Stack.new([1, 2, 3])
  end

  def teardown
    @stack = nil
  end

  def test_empty
    @stack.clear!
    assert @stack.empty?
  end

  def test_clear
    assert_empty @stack.clear!
  end

  def test_push
    @stack.push! 4
    assert_equal [1, 2, 3, 4], @stack.to_a
  end

  def test_pop
    val = @stack.pop!
    assert_equal 3, val
    assert_equal [1, 2], @stack.to_a
  end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
