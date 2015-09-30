require 'minitest/autorun'
require_relative 'wordbrain'
require 'debase'

class WordBrainTest < MiniTest::Test
  def setup
    @game = WordBrain.new
    @board = [%w(c a), %w(l m), %w(i n)]
  end

  def test_initialization
    assert @game.words.count > 0
    assert @game.words["chair"]
    assert !@game.words["abcd"]

    # assert @game.board
    # assert_equal 'c', @game.board[0][0]
    # assert_equal 'a', @game.board[0][1]
    # assert_equal 'l', @game.board[1][0]
    # assert_equal 'm', @game.board[1][1]

    # assert_equal 2, @game.num_cols
    # assert_equal 3, @game.num_rows
  end

  def test_play_4
    #[ c a ]
    #[ l m ]
    @board = [%w(c a), %w(l m)]
    @game.print_board @board
    words_4 = @game.play([], @board, [4])
    words_2 = @game.play([], @board, [2])
    # @game.print_word_list
    assert_equal ["calm", "clam"], words_4
    assert_equal ["am", "al", "la", "ma"], words_2
  end

  def test_play_6
    #[ c a ]
    #[ l m ]
    #[ i n ]
    #[ g x ]
    @board = [%w(c a), %w(l m), %w(i n), %w(g x)]
    @game.print_board @board
    words = @game.play([], @board, [7])
    # @game.print_word_list
    assert_equal ["calming"], words
  end


  def test_fill_blank_array
    expected = [[false,false], [false, false], [false, false]]
    visited = @game.fill_blank_array(expected)
    assert_equal expected, visited
  end

  def test_create_word_lists
    raw_words = @game.word_list
    numbered_word_list = @game.create_word_lists(raw_words)
    assert numbered_word_list[4]["calm"]
    assert numbered_word_list[6]["shield"]
  end

  def test_reduce_board
    visited = [[true,false], [false, true], [false, false]]
    board = [%w(a b), %w(c d), %w(e f)]
    reduced_board = @game.reduce_board(board, visited)
    assert_equal [[nil, "b"], ["c", nil], %w(e f)], reduced_board
  end

  def test_shift_board_down
    board = [["x", "y"], [nil, "b"], ["c", nil], %w(e f)]
    shifted_board = @game.shift_board_down(board)
    assert_equal [[nil, nil], ["x", "y"], ["c", "b"], %w(e f)], shifted_board
  end

  def test_board_with_nils
    @board = [[nil, nil], [nil, "c"], %w(t a)]
    words_3 = @game.play([], @board, [3])
    assert_equal ["cat", "act"], words_3
  end

  def test_multi_round
    @board = [%w(o o t), %w(d a r), %w(d r c)]
    words = @game.play([], @board, [3, 6])
    @board = [%w(l k s), %w(a o c), %w(t e p)]
    words = @game.play([], @board, [5, 4])
    p words
  end


end
