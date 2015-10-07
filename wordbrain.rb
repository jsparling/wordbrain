class WordBrain
  include Math
  attr_accessor :words

  def initialize
    @words = word_list
  end

  def convert_string_to_board(string_array)
    length = sqrt(string_array.length).to_i

    board = []
    length.times do |index|
      row = []
      length.times do ||
        row << string_array.shift
      end
      board[index] = row
    end
    board
  end

  def play(board, target_lengths)
    if board[0].length == 1
      board = convert_string_to_board(board)
    end

    master_list = []
    play_recursive(master_list, [], board, target_lengths, 0)
    master_list.uniq
  end

  def play_recursive(master_list, current_word_list, board, target_lengths, level)
    if (target_lengths.length) == level
      master_list << current_word_list
      return
    end

    new_found_words = play_single_word(board, target_lengths[level])

    return if new_found_words.empty?

    new_found_words.each_with_index do |found|
      temp_word_list = current_word_list.map(&:dup)
      current_word_list << found[0]
      new_visited = found[1]
      temp_board = reduce_and_shift_board(board, new_visited)
      play_recursive(master_list, current_word_list, temp_board, target_lengths, level+1)
      current_word_list = temp_word_list
    end
  end

  def play_single_word(board, target_length)
    visited = fill_blank_array(board)
    found_words = []
    board.each_with_index do |row, row_index|
      row.each_with_index do |_, col_index|
        find_words(found_words, board, visited.map(&:dup), row_index, col_index, "", target_length)
      end
    end
    found_words.uniq
  end

  def find_words(found_words, board, visited, row, col, current_word, target_length)
    return found_words if find_words_base_case?(board, visited, row, col)

    current_word = "#{current_word}#{board[row][col]}"
    visited[row][col] = true

    if current_word.length == target_length
      if @words[current_word]
        found_words << [current_word, visited]
      end
    else
      find_words(found_words, board, visited.map(&:dup), row-1, col-1, current_word, target_length) # up-left
      find_words(found_words, board, visited.map(&:dup), row-1, col,   current_word, target_length) # up
      find_words(found_words, board, visited.map(&:dup), row-1, col+1, current_word, target_length) # up-right
      find_words(found_words, board, visited.map(&:dup), row,   col+1, current_word, target_length) # right
      find_words(found_words, board, visited.map(&:dup), row+1, col+1, current_word, target_length) # right-down
      find_words(found_words, board, visited.map(&:dup), row+1, col,   current_word, target_length) # down
      find_words(found_words, board, visited.map(&:dup), row+1, col-1, current_word, target_length) # left-down
      find_words(found_words, board, visited.map(&:dup), row,   col-1, current_word, target_length) # left
    end
  end

  def find_words_base_case?(board, visited, row, col)
    return true if row < 0 || row >=board.length
    return true if col < 0 || col >= board[0].length
    return true if visited[row][col]
    return true if board[row][col].nil?
    false
  end

  def reduce_and_shift_board(board, visited)
    shift_board_down(reduce_board(board, visited))
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
      shift_column_down(return_board, col)
    end
    return_board
  end

  def shift_column_down(return_board, col)
    column = []
    (return_board.length - 1).downto(0) do |row|
      column << return_board[row][col]
    end

    new_column = column.compact
    (return_board.length - 1).downto(0) do |row|
      return_board[row][col] = new_column.shift
    end
  end

  def fill_blank_array(board)
    num_rows = board.length
    num_cols = board[0].length
    Array.new(num_rows) { Array.new(num_cols){ false }}
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
