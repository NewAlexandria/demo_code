#!/bin/ruby

require 'json'
require 'stringio'


#
# Complete the 'fizzBuzz' function below.
#
# The function accepts INTEGER n as parameter.
#

def fizzBuzz(x)
    return unless x
    fizzBuzzOne = -> (n) do
        return unless n
        f = (n % 3 == 0) ? 'Fizz' : nil
        b = (n % 5 == 0) ? 'Buzz' : nil
        return n unless f || b
        return "#{f}#{b}"
    end
    (1..x).map{|i| puts fizzBuzzOne.call(i) }
end

n = gets.strip.to_i

fizzBuzz n

