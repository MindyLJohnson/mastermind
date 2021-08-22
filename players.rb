class Player
  def initialize(name, mode)
    @name = name
    @mode = mode
  end
end

class Human < Player
  def initialize(name, mode)
    super(name, mode)
  end
end

class Computer < Player
    def initialize(name, mode)
      super(name, mode)
    end  
end