class WordBrain
  attr_reader :words

  def initialize
    @words = word_list
  end

  def fill_blank_array(board)
    num_rows = board.length
    num_cols = board[0].length
    Array.new(num_rows) { |i| Array.new(num_cols){ false }}
  end

  def start(board, target_lengths)
    found_word_list = play([], board, target_lengths)

    create_keeper_list(found_word_list, target_lengths.length)
  end

  def create_keeper_list(found_word_list, number_of_words)
    keeper_list = []
    found_word_list.each do |word_array|
      keeper_list << word_array if word_array.length == number_of_words
    end
    keeper_list.uniq
  end

  def play(found_word_list, board, target_lengths)
    found_word_list ||= []
    @calls = 0
    board.each_with_index do |row, row_index|
      row.each_with_index do |_, col_index|
        visited = fill_blank_array(board)
        find_words(found_word_list, board, visited, row_index ,col_index, "", target_lengths[0], target_lengths)
      end
    end
    # p @calls
    found_word_list
  end

  def find_words(found_word_list, board, visited, row, col, current_word, current_word_length, target_lengths)
    num_rows = board.length
    num_cols = board[0].length
    @calls += 1
    return if row < 0 || row >= num_rows
    return if col < 0 || col >= num_cols
    return if visited[row][col]
    return if board[row][col].nil?

    current_word = "#{current_word}#{board[row][col]}"
    visited[row][col] = true

    if current_word.length == current_word_length
      if @words[current_word]
        found_word_list << current_word
        if target_lengths.length > 1
          reduced_board = reduce_board(board, visited)
          shifted_board = shift_board_down(reduced_board)
          words = play([], shifted_board, target_lengths.drop(1))
          if words.length > 0
            found_word_list << [current_word, words]
          end
        end
      end
    else
      find_words(found_word_list, board, visited.map(&:dup), row-1, col-1, current_word, current_word_length, target_lengths) # up-left
      find_words(found_word_list, board, visited.map(&:dup), row-1, col,   current_word, current_word_length, target_lengths) # up
      find_words(found_word_list, board, visited.map(&:dup), row-1, col+1, current_word, current_word_length, target_lengths) # up-right
      find_words(found_word_list, board, visited.map(&:dup), row,   col+1, current_word, current_word_length, target_lengths) # right
      find_words(found_word_list, board, visited.map(&:dup), row+1, col+1, current_word, current_word_length, target_lengths) # right-down
      find_words(found_word_list, board, visited.map(&:dup), row+1, col,   current_word, current_word_length, target_lengths) # down
      find_words(found_word_list, board, visited.map(&:dup), row+1, col-1, current_word, current_word_length, target_lengths) # left-down
      find_words(found_word_list, board, visited.map(&:dup), row,   col-1, current_word, current_word_length, target_lengths) # left
    end
  end

  def reduce_board(board, visited)
    return_board = board.map(&:dup)
    return_board.each_with_index do |row, row_index|
      row.each_with_index do |_, col_index|
        if visited[row_index][col_index]
          return_board[row_index][col_index] = nil
        end
      end
    end
    return_board
  end

  def shift_board_down(board)
    return_board = board.map(&:dup)
    (return_board[0].length - 1).downto(0) do |col|
      (return_board.length - 1).downto(0) do |row|
        if return_board[row][col].nil? && row > 0
          return_board[row][col] = return_board[row-1][col]
          return_board[row-1][col] = nil
        end
      end
    end
    return_board
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

  def print_board(board)
    board.each do |row|
      p row
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
end
