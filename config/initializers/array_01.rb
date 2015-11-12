class Array

  def with_nil
    empty? ? self.push(nil) : self
  end

end