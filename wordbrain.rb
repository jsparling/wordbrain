class WordBrain
  attr_reader :words, :num_cols, :num_rows
  attr_accessor :board, :found_word_list

  def initialize
    @words = word_list
    @found_word_list = []
  end

  def board=(board)
    @board = board
    @num_rows = @board.length
    @num_cols = @board[0].length
  end

  def fill_blank_array
    Array.new(num_rows) { |i| Array.new(num_cols){ false }}
  end

  def play(board, target_length)
    @board = board
    @found_word_list = []
    @calls = 0
    @board.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        visited = fill_blank_array
        find_words(visited, row_index ,col_index, "", target_length)
      end
    end
    p @calls
    found_word_list
  end

  def print_board
    @board.each do |row|
      p row
    end
  end

  def print_word_list
    p found_word_list
  end

  def find_words(visited, row, col, current_word, target_length)
    @calls += 1
    return if row < 0 || row >= num_rows
    return if col < 0 || col >= num_cols
    return if visited[row][col]

    current_word = "#{current_word}#{@board[row][col]}"

    if current_word.length == target_length
      if @words[current_word]
        found_word_list << current_word
      end
    else
      visited[row][col] = true
      find_words(visited.map(&:dup), row-1, col-1, current_word, target_length) # up-left
      find_words(visited.map(&:dup), row-1, col,   current_word, target_length) # up
      find_words(visited.map(&:dup), row-1, col+1, current_word, target_length) # up-right
      find_words(visited.map(&:dup), row,   col+1, current_word, target_length) # right
      find_words(visited.map(&:dup), row+1, col+1, current_word, target_length) # right-down
      find_words(visited.map(&:dup), row+1, col,   current_word, target_length) # down
      find_words(visited.map(&:dup), row+1, col-1, current_word, target_length) # left-down
      find_words(visited.map(&:dup), row,   col-1, current_word, target_length) # left
    end
  end

  def word_list
    words = {}
    File.open("./en.txt") do |file|
      file.each do |line|
        words[line.strip] = true
      end
    end
    words
  end

  # This is not necessary, the regular method to get words is very fast
  def create_word_lists(words)
    numbered_word_list = Array.new(29) { |i| {} }
    words.each do |word|
      len = word[0].length
      numbered_word_list[len][word[0]] = true
    end
    numbered_word_list
  end

end
