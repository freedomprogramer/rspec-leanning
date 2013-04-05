require 'helper_spec'

describe Calculator do
  describe '#add' do
    it 'returns the sum of its arguments' do
      expect(Calculator.new.add(1, 2)).to eq(3)
    end
  end
end












































=begin
class Calculator
  def add(a,b)
    a + b
  end
end
$ rspec spec/calculator_spec.rb --format doc
Calculator
  #add
    returns the sum of its arguments
=end
