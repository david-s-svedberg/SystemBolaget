class String
  def wrap(pre, post)
    return self.prepend(pre) << post
  end

  def wrap_with_parenthesis()
    return self.wrap('(', ')')
  end
end
