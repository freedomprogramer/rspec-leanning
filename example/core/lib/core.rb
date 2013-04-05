class User
  def initialize(role="visitor")
    @identity = role
  end

  def read_protected
    if @identity.eql?("admin")
      "welcome sir"
    else
      "you have no rights to visit here"
    end
  end
end

class Stack
end

##  You: Describe a account
##  Somebody else: It should have a balance of zero

class Money
  def initialize(num, type)
    @num = num
    @type = type
  end

  def total_money
    return @num
  end
end

class Account
  def balance
    return Money.new(0, :USD).total_money
  end
end


