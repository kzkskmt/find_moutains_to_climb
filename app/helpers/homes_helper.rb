module HomesHelper
  def add_space(word)
    word.size == 2 ? "#{word.chars.first}　#{word.chars.last}" : word
  end
end
